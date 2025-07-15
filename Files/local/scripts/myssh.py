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
import textwrap

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

# === Helper functions ===

def log_cmd(cmd):
    print(f"+ {' '.join(shlex.quote(str(c)) for c in cmd)}")

def run(cmd, check=True, capture_output=False, verbose=False, **kwargs):
    """Run a command, and output it via print if verbose is set."""
    try:
        if verbose:
            log_cmd(cmd)
        return subprocess.run(cmd, check=check, capture_output=capture_output, text=True, **kwargs)
    except KeyboardInterrupt:
        print("\n[✋] Process interrupted by user.")
        sys.exit(0)
    except Exception as e:
        raise

def ssh_cmd(args, remote_cmd, control_path=None, allocate_tty=False):
    """Run a remote command over SSH."""
    base = ["ssh"]
    if control_path:
        base += ["-o", f"ControlPath={control_path}"]
    if allocate_tty:
        base.append("-t")
    base += [args.target, remote_cmd]
    return run(base, verbose=args.verbose)

def get_control_path(config):
    """Get path to ControlMaster file for this target."""
    return os.path.expanduser(f"~/.ssh/cm_socket/{config.user}@{config.host}:{config.port}")

def control_check(args):
    """Check if ControlMaster is active for this target."""
    try:
        run(["ssh", "-O", "check", args.target], check=True, capture_output=True, verbose=args.verbose)
        return True
    except subprocess.CalledProcessError:
        return False

def open_control_master(control_path, args):
    """Open ControlMaster in background."""
    try:
        os.makedirs(os.path.dirname(control_path), exist_ok=True)
        run(["ssh", "-M", "-N", "-f", "-o", f"ControlPath={control_path}", args.target], verbose=args.verbose)
        return True
    except subprocess.CalledProcessError:
        print("[╥﹏╥] Failed to start SSH ControlMaster session.")
        return False

def detect_config(args):
    """Check the local .ssh configuration to see which parameters will actually be used."""
    try:
        result = subprocess.run(
            ["ssh", "-G", args.target],
            check=True,
            capture_output=True,
            text=True,
        )
        ssh_config = dict(
            line.strip().split(None, 1)
            for line in result.stdout.strip().splitlines()
            if " " in line
        )
        user = ssh_config.get("user", getpass.getuser()) # Second parameter = default
        host = ssh_config.get("hostname", args.target) # Use full "hostname" instead of short "host"
        port = ssh_config.get("port", "22")
        return Config(user, host, port)
    except subprocess.CalledProcessError:
        # Fallback if parsing fails
        if "@" in args.target:
            user, host = args.target.split("@", 1)
            return Config(user, host, "22")
        return Config(getpass.getuser(), args.target, "22")

def can_rsync(host, username, multiplexer_active):
    return (username == getpass.getuser()) and multiplexer_active

def check_remote_tmux(args):
    try:
        ssh_cmd(args, "hash tmux")
        print("[☆☆☆]  ]  ] Found remote tmux.")
        return True
    except subprocess.CalledProcessError:
        return False

def check_remote_screen(args):
    """Check if screen is available on remote system."""
    try:
        ssh_cmd(args, "hash screen")
        print("[☆☆☆]  ]  ] Found remote screen.")
        return True
    except subprocess.CalledProcessError:
        return False

def rsync_remote_files(args):
    """Sync config files to remote target."""
    try:
        print("[⌲⌲⌲] Syncing config files to remote...")
        config_local = os.path.expandvars("$HOME/git/wsl-terminal-setup/Files/remote/.config.custom/")
        config_remote = f"{args.target}:.config.custom/"
        terminfo_local = os.path.expandvars("$HOME/git/wsl-terminal-setup/Files/remote/.terminfo/")
        terminfo_remote = f"{args.target}:.terminfo/"
        if (args.verbose):
            my_args="-rEtLzv"
        else:
            my_args="-rEtLz"
        run(["rsync", my_args, "--delete", config_local, config_remote], verbose=args.verbose)
        run(["rsync", my_args, "--delete", terminfo_local, terminfo_remote], verbose=args.verbose)
    except subprocess.CalledProcessError:
        print("[╥﹏╥] Failed to sync files to remote target!")
        raise

def run_ssh_multiplexer(args):
    """Open ssh session, then open remote bash with custom config to start terminal multiplexer"""
    remote_cmd = "bash --rcfile $HOME/.config.custom/bash/.bashrc -i -c 'exit'"
    ssh_cmd(args, remote_cmd, allocate_tty=True)

def run_ssh(args):
    """Open simple ssh session with tty."""
    run(["ssh", args.target], allocate_tty=True, verbose=args.verbose)

# === Main Logic ===

def main():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=description,
    )

    parser.add_argument("target", help="SSH target: [USER@]HOST[:PORT]")
    parser.add_argument("-v", "--verbose", action="store_true", help="Print commands before execution (like bash -x)")
    args = parser.parse_args()

    config = detect_config(args)
    control_path = get_control_path(config)

    multiplexer_active = control_check(args)
    if not multiplexer_active:
        print("[⌘_⌘] No active ControlMaster. Attempting to open one...")
        if open_control_master(control_path, args):
            multiplexer_active = True

    # Remote shell launcher logic
        print("[~_⊙] Checking available remote terminal multiplexer...")
        if ( check_remote_tmux(args) or check_remote_screen(args) ):
            if ( config.user == os.getlogin() ):
                rsync_remote_files(args)
            else:
                print(f"[ಠ_ಠ] Connecting as user {config.user}, skipping config transfer...")
            print("[☆☆☆]  ]  ] Launching ssh multiplexer...")
            run_ssh_multiplexer(args)
        else:
            print("[ಠ_ಠ] Falling back to basic ssh...")
            run_ssh(args)

    # Cleanup
    if multiplexer_active:
        print("[☆☆☆]  ]  ] Closing ControlMaster session.")
        run(["ssh", "-O", "exit", args.target], verbose=args.verbose)
    else:
        print(f"[╥﹏╥] No active ControlMaster session found for {args.target}!")

if __name__ == "__main__":
    main()

