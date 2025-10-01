#!/usr/bin/env python3

import os
import subprocess
import sys
import shlex
from pathlib import Path
from datetime import datetime
import getpass
import argparse
import socket
import textwrap # Text manipulation, e.g.: Remove any common leading whitespace from every line in text.
from colorama import Fore, Back, Style # print in color

# === Config ===

description=textwrap.dedent('''\
    Smart SSH utility
    -----------------

    This script extends upon normal ssh functionality.

    When supported by remote terminal, it does:
        Open a ControlMaster ssh session
        Sync relevant config files
        Start remote tmux or screen
    Otherwise:
        Fallback to standard ssh
''')

# === Classes ===

class Config:
    def __init__(self, user, host, port):
        self.user = user
        self.host = host
        self.port = port

# === Global vars ===

DATA_DIR = Path.home() / ".local" / "share" / "ssh"
BLACKLIST_FILE = DATA_DIR / "hosts_without_multiplexing.txt"
CONTROLMASTER_ACTIVE = False
ARGS = None

# === Helper functions ===

def log_cmd(cmd):
    print(f"+ {' '.join(shlex.quote(str(c)) for c in cmd)}")

def run_no_loop(cmd, verbose=False, **kwargs):
    """Run a command, but don't invoke cleanup on failure (for use inside cleanup)."""
    try:
        if verbose:
            log_cmd(cmd)
        return subprocess.run(cmd, check=False, text=True, **kwargs)
    except Exception as e:
        print(f"{Fore.RED}[╥﹏╥] Warning: Command failed in cleanup: {e}{Style.RESET_ALL}")

def run(cmd, check=True, capture_output=False, text=True, timeout=None, verbose=False, **kwargs):
    """Run a command, and output it via print if verbose is set."""
    try:
        if verbose:
            log_cmd(cmd)
        return subprocess.run(cmd, check=check, capture_output=capture_output, text=text, timeout=timeout, **kwargs)
    except KeyboardInterrupt:
        print(f"\n✋ Process interrupted by user.")
        cleanup()
    except Exception as e:
        raise

def ssh_cmd(remote_cmd, timeout=None, allocate_tty=False, capture_output=False):
    """Run a remote command over SSH."""
    base = ["ssh"]
    if allocate_tty:
        base.append("-t")
    base += [ARGS.target, remote_cmd]
    return run(base, timeout=timeout, capture_output=capture_output, verbose=ARGS.verbose)

# === Execution functions ===

def cleanup():
    """Cleanup everything left behind"""
    if CONTROLMASTER_ACTIVE:
        print(f"{Fore.CYAN}[⌘_⌘] Closing ControlMaster session...{Style.RESET_ALL}")
        run_no_loop(["ssh", "-O", "exit", ARGS.target], verbose=ARGS.verbose)

    run_no_loop(["tmux", "setw", "automatic-rename", "on"], verbose=ARGS.verbose)
    run_no_loop(["tmux", "set-option", "-w", "@ssh-connected", ""], verbose=ARGS.verbose) # Set ssh-connected to null, and therefore enable local keybinds
    sys.exit(0)

def get_control_path(config):
    """Get path to ControlMaster file for this target."""
    return os.path.expanduser(f"~/.ssh/cm_socket/{config.user}@{config.host}:{config.port}")

def controlmaster_check():
    """Check if ControlMaster is active for this target."""
    res = run(["ssh", "-O", "check", ARGS.target], check=False, capture_output=True, verbose=ARGS.verbose)
    if res.returncode == 0:
        return True
    else:
        return False

def open_control_master(config):
    """Open ControlMaster in background."""
    control_path = get_control_path(config)
    os.makedirs(os.path.dirname(control_path), exist_ok=True)

    # Start master
    res = run(["ssh", "-M", "-N", "-f", "-o", f"ControlPath={control_path}", f"{config.user}@{config.host}", "-p", str(config.port)], check=False)
    if res.returncode != 0:
        return False

    return True

def detect_config():
    """Check the local .ssh configuration to see which parameters will actually be used."""
    try:
        result = run(["ssh", "-G", ARGS.target], capture_output=True, verbose=ARGS.verbose)
        ssh_config = dict(
            line.strip().split(None, 1)
            for line in result.stdout.strip().splitlines()
            if " " in line
        )
        user = ssh_config.get("user", getpass.getuser()) # Second parameter = default
        host = ssh_config.get("hostname", ARGS.target) # Use full "hostname" instead of short "host"
        port = ssh_config.get("port", "22")
        return Config(user, host, port)
    except subprocess.CalledProcessError:
        # Fallback if parsing fails
        if "@" in ARGS.target:
            user, host = ARGS.target.split("@", 1)
            return Config(user, host, "22")
        return Config(getpass.getuser(), ARGS.target, "22")

def load_blacklist():
    if BLACKLIST_FILE.exists():
        return set(line.strip() for line in BLACKLIST_FILE.read_text().splitlines() if line.strip())
    return set()

def save_to_blacklist(entry):
    with open(BLACKLIST_FILE, "a") as f:
        f.write(entry + "\n")

def nothing_found(command):
    print(f"{Fore.YELLOW}[x.x] No {command}.{Style.RESET_ALL}")
    return False

def check_remote_command(command):
    try:
        result = ssh_cmd(f"hash {command}", timeout=1, capture_output=True)
        if (result.stdout):
            # hash has no output when command exists
            return nothing_found(command)
        else:
            print(f"{Fore.GREEN}[^.^] Found remote {command}.{Style.RESET_ALL}")
            return True
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired):
        return nothing_found(command)

def rsync_remote_files():
    """Sync config files to remote target."""
    try:
        print(f"{Fore.CYAN}[⌘_⌘] Syncing config files to remote...{Style.RESET_ALL}")
        config_local = os.path.expandvars("$HOME/git/wsl-terminal-setup/Files/remote/.config.custom/")
        config_remote = f"{ARGS.target}:.config.custom/"
        terminfo_local = os.path.expandvars("$HOME/git/wsl-terminal-setup/Files/remote/.terminfo/")
        terminfo_remote = f"{ARGS.target}:.terminfo/"
        if (ARGS.verbose):
            my_args="-rEtLzv"
        else:
            my_args="-rEtLz"
        run(["rsync", my_args, "--delete", config_local, config_remote], verbose=ARGS.verbose)
        run(["rsync", my_args, "--delete", terminfo_local, terminfo_remote], verbose=ARGS.verbose)
    except Exception:
        print(f"{Fore.RED}[╥﹏╥] Failed to sync files to remote target!{Style.RESET_ALL}")
        cleanup()
        raise

def run_ssh_multiplexer():
    """Open ssh session, then open remote bash with custom config to start terminal multiplexer"""
    cmd = ["ssh", "-t", ARGS.target, "bash --rcfile $HOME/.config.custom/bash/.bashrc -i"]
    print(f"{Fore.CYAN}[⌘_⌘] Launching custom ssh environment...{Style.RESET_ALL}")
    run(["tmux", "set-option", "-w", "@ssh-connected", "1"], verbose=ARGS.verbose) # Disables local keybinds to not interfere with remote bindings
    res = run(cmd, check=False, verbose=ARGS.verbose)
    if res.returncode != 0:
        print(f"{Fore.RED}[╥﹏╥] Failed while trying to launch custom ssh environment!{Style.RESET_ALL}")
        cleanup()

def run_ssh():
    """Open simple ssh session with tty."""
    print(f"{Fore.CYAN}[⌘_⌘] Connecting via basic ssh...{Style.RESET_ALL}")
    res = run(["ssh", "-t", ARGS.target], check=False, verbose=ARGS.verbose)
    if res.returncode != 0:
        print(f"{Fore.RED}[╥﹏╥] Failed to open basic ssh session!{Style.RESET_ALL}")
        cleanup()

# === Main Logic ===

def main():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=description,
    )

    # For parser, action="store_true" will result in default value: FALSE when argument is unspecified.
    parser.add_argument("target", help="SSH target: [USER@]HOST[:PORT]")
    parser.add_argument("-v", "--verbose", action="store_true", help="Print commands before execution (like bash -x)")
    parser.add_argument("--transfer", action="store_true", help="Force transfer of config files to remote location, even for other users than local")
    global ARGS
    ARGS = parser.parse_args()
    if not ARGS:
        print(f"{Fore.RED}[╥﹏╥] Could not query script arguments.{Style.RESET_ALL}")
        cleanup()

    # Ensure data dir exists
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    run(["tmux", "rename-window", f"🔐 {ARGS.target}"], verbose=ARGS.verbose)

    config = detect_config()

    blacklist = load_blacklist()

    if config.host in blacklist:
        print(f"{Fore.YELLOW}[x.x] Host {config.host} previously blacklisted as no SSH ControlMaster in {BLACKLIST_FILE}{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}====> Remove with:{Fore.MAGENTA} sed -i '/{config.host}/d' {BLACKLIST_FILE}{Style.RESET_ALL}")
        run_ssh()
        cleanup()

    global CONTROLMASTER_ACTIVE
    CONTROLMASTER_ACTIVE = controlmaster_check()

    # Trying to open ControlMaster...
    if not CONTROLMASTER_ACTIVE:
        print(f"{Fore.CYAN}[⌘_⌘] No active ControlMaster. Attempting to open one...{Style.RESET_ALL}")
        CONTROLMASTER_ACTIVE = open_control_master(config)

    # Remote shell launcher logic
    print(f"{Fore.CYAN}[~_⊙] Checking available remote terminal multiplexer...{Style.RESET_ALL}")
    if ( check_remote_command("tmux") or check_remote_command("screen") ):
        if ( ARGS.transfer is False and config.user != os.environ.get("USER") ):
            # Skip config transfer if force_transfer argument is false and user is not the same
            print(f"{Fore.YELLOW}[ಠ_ಠ] Connecting as user {config.user}, skipping config transfer. Use --transfer to force transfer config...{Style.RESET_ALL}")
        else:
            rsync_remote_files()
        run_ssh_multiplexer()
    else:
        CONTROLMASTER_ACTIVE = controlmaster_check()
        if not CONTROLMASTER_ACTIVE:
            print(f"{Fore.YELLOW}[x.x] Host {config.host} does not support SSH ControlMaster. Adding to {BLACKLIST_FILE}.{Style.RESET_ALL}")
            save_to_blacklist(config.host)
        run_ssh()

    cleanup()

if __name__ == "__main__":
    main()

