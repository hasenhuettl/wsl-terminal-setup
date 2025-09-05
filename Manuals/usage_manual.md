# Usage Manual

This manual provides a quick overview and useful commands/configurations for the main tools and environments in your development setup.

---

## WSL (Windows Subsystem for Linux)

WSL allows you to run a Linux environment directly on Windows without the need for a virtual machine.

---

### Administering WSL in Windows CMD or PowerShell

You can manage WSL distributions and sessions directly from Windows Command Prompt or PowerShell using WSL commands.

- `wsl -v`
  Check the installed WSL version.
- `wsl --list --verbose`
  List all installed WSL distributions and their status.
- `wsl --shutdown`
  Restart all running WSL sessions by shutting them down.

---

## Windows Terminal (WinTerminal)

A modern terminal application that supports multiple tabs and shells.

### Hotkeys
- `Ctrl + T`
  Open a new tab.
- `Ctrl [+ Shift] + Tab`
  Navigate between tabs.

---

## Linux OS

This script was implemented and tested using WSL Ubuntu 20.04, 22.04, and 24.04. Other linux distributions should work after adapting the installation scripts accordingly.

---

## Tmux (Terminal Multiplexer)

Tmux allows multiple terminal sessions to be accessed and controlled from a single window.

### Configuration
- Config can be edited & applied with alias `trc`
  - `trc` is my abbreviation for "tmux rc". See [the zsh section](#zsh) on how to override aliases.

### Hotkeys
- `Ctrl + Shift + Left/Right Arrow`
  Navigate panes on the host machine.
- `Shift + Left/Right Arrow`
  Navigate panes on the remote machine.
- `Ctrl + b`
  Enter Tmux command mode on the host.
- `Ctrl + a`
  Enter Tmux command mode on the remote machine.
- In command mode, press `c` to create a new pane.

---

## Zsh (Z shell)

Zsh is an extended shell with more powerful features than bash.

### Configuration
- Config can be edited & applied with alias `zrc`
  - I split some of the configs into multiple files. A neovim window should be opened, showing the different files in the folder. Refer to [the neovim section](#neovim) for further infos.
  - Place your custom config (aliases, options, etc.) within custom.zsh, it will be loaded last and overwrite previous settings.


### Hotkeys
- `Ctrl + Right/Left Arrow`
  Move cursor forward/backward by a whole word.
- `Alt + Left Arrow` or `Alt + Backspace`
  Delete the word before the cursor.
- `Alt + Right Arrow` or `Alt + Delete`
  Delete the word after the cursor.
- Text + `Cursor Up/Down`
  Navigate command history filtered by what you've typed so far.

---

## Neovim

An improved version of Vim with better extensibility and configuration.

### Configuration
- Config can be edited & applied with alias `nrc`

### Features
- Supports most Vim commands.
- Shows style and inserts indentation based on filetype.
- Shows changes made in git-committed files in a sidebar.

### Usage
- Neovim handling for the user is nearly the same as basic vi/vim. It is highly recommended to at least look up basic vim commands beforehand.
- **Do not give up after initially seeing all the available keybinds.** Start with the basics, and soon you'll learn to love neovim. Trust me.

### Hotkeys
- `Shift + i` to enter a paste-friendly insert mode that disables UI elements that could interfere with pasting text. Press `Escape` to exit this mode.
- `Spacebar` (LEADER key for the snacks plugin) or `,` (LEADER key for Neovim) to display your shortcuts, e.g., save/quit with `, + w/q` instead of `:w/q`.
- `.`, or `gcc` to comment/uncomment the current line based on filetype.
- Swap between files by pressing `-` to open the Oil file manager, or `Ctrl + n` / `Ctrl + p` to switch to next/previous file.
- run `:Inspect` on an element to find out e.g. why the element is a different color, use `:help Command` to see what a command does

---

## Custom SSH

The ssh command is aliased to run $HOME/scripts/myssh.py. You can use either `ussh` or `\ssh` to run standard ssh.

### Usage
- Ensure remote system has required packages installed (e.g. rsync, curl, tmux, zsh -> refer to Install/Bash/install_packages.sh)
- View available parameters via `ssh --help`
- Use standard `ssh [username@]host[:port]` to connect

### Features
- Synchronize configuration files for neovim, tmux, zsh, etc. to remote system (Folder: "$HOME/.config.custom"), if either:
  - Username on host and remote is the same
  - `--transfer` parameter is provided to force file transfer. **(THIS WILL ALWAYS OVERWRITE REMOTE FOLDER "$HOME/.config.custom" AND "$HOME/.terminfo"!)**
- Automatically creates a new terminal multiplexer session, either tmux or screen (if supported by remote system)
- SSH session multiplexing via ControlMaster (if supported by remote system)
  - Reuse same connection (only input remote password once)
  - SSH session restore with tmux (re-open used remote tabs when host crashes)

---

