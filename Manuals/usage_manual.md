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
- `Ctrl + Shift + Tab`
  Navigate backwards between open tabs.

---

## Linux OS

This script was implemented and tested using WSL Ubuntu 20.04, 22.04, and 24.04. Other linux distributions should work after adapting the installation scripts accordingly.

---

## Tmux (Terminal Multiplexer)

Tmux allows multiple terminal sessions to be accessed and controlled from a single window.

### Configuration
- Config file located at `~/.tmux.conf`.
- When using ssh (aliases to ssh=~/custom/myssh.sh) to connect to a remote machine, separate bindings are used, located at `~/custom/ssh/.tmux.conf`.

### Hotkeys
- `Ctrl + Shift + Left/Right Arrow`
  Navigate panes on the host machine.
- `Shift + Left/Right Arrow`
  Navigate panes on the remote machine.
- `Ctrl + b`
  Enter Tmux command mode on the host.
- `Ctrl + a`
  Enter Tmux command mode on the remote machine.
- In command mode, press `b` to create a new tab.

---

## Zsh (Z shell)

Zsh is an extended shell with more powerful features than bash.

### Configuration
- Config files located in `~/.config/zsh/`.

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
- Config files located in `~/.config/nvim`.

### Features
- Supports most Vim commands.
- Shows style and inserts indentation based on filetype.
- Shows changes made in git-committed files in a sidebar.

### Hotkeys
- `Shift + i` to enter a paste-friendly insert mode that disables UI elements that could interfere with pasting text. Press `Escape` to exit this mode.
- `Spacebar` (LEADER key for the snacks plugin) or `,` (LEADER key for Neovim) to display your shortcuts, e.g., save/quit with `, + w/q` instead of `:w/q`.
- `gcc` to comment/uncomment the current line based on filetype.
- Swap between files by pressing `-` to open the Oil file manager, or `Ctrl + n` / `Ctrl + p` to switch to next/previous file.
- run `:Inspect` on an element to find out e.g. why the element is a different color, use `:help Command` to see what a command does

---


