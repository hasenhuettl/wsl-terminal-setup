# INTRODUCTION

This setup was made for people, who:

 - Are on a **WINDOWS** machine
 - Would like to connect to **ONE OR MORE REMOTE LINUX TERMINALS** via **SSH**
 - Want something more than opening 15 different PuTTY windows

# Setup

 - WSL - Lets you run a Linux environment directly on Windows without a virtual machine.
 - Ubuntu - Linux distribution that runs inside WSL (can be modified).
 - Windows Terminal - A terminal app from Microsoft where you can switch between shells on Windows.
 - Zsh - Chosen command-line shell with great plugin support.
 - Tmux - Lets you split your terminal into multiple panes and windows.
 - Neovim - A modernized version of Vim with great plugin support.

# INSTALLATION

THE INSTALLATION SCRIPTS INCLUDE POTENTIALLY RISKY COMMANDS!

I cannot guarantee that they will also work flawlessly on your system!

USE AT YOUR OWN RISK!

## Windows:

### Pre-requisites:
 - Windows 10 version 2004 or higher
 - Windows 11+
 - Working WSL
 - Working winget
 - Enabled Virtualization in your BIOS/UEFI

To check if WSL is working, open PowerShell, and execute:

```powershell
wsl --version
```

To check if winget is working, open PowerShell, and execute:

```powershell
winget --version
```

If your winget has issues, you could also try to manually download "Windows Terminal" from the Microsoft Store, then comment out the winget line in Install/PowerShell/Install_WSL.ps1.

To check if Virtualization is enabled, open Task Manager, go to Performance Tab, select CPU, and look for "Virtualization: Enabled".

If Virtualization is missing or set to False, please enable Virtualization in the BIOS.

### What will be done:

 - Disables execution policy
 - Downloads the files to $ParentFolder\wsl-terminal-setup
 - Installs WSL-Ubuntu, Windows Terminal, and JetBrainsMono Font for icon display
 - Pastes config files to their respective locations (WSL, WinTerminal)
 - ! If you have not installed the WSL-Ubuntu configured in Config/config.ps1 yet:
   - Installer will ask you to reboot during the installation!
   - Please save your important files and close all other programs before reboot!
   - After closing all other programs, press any key to reboot!
 - Enables execution policy ("Restricted")

### Install:

 - Open PowerShell:

```
$ParentFolder = "$env:USERPROFILE\git"
$Uri = "https://github.com/hasenhuettl/wsl-terminal-setup/archive/refs/heads/main.zip"
$Tmp = "$env:TEMP\wsl-terminal-setup.zip"

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
Set-Location "$env:USERPROFILE"
Invoke-WebRequest -Uri "$Uri" -OutFile "$Tmp"
Expand-Archive -Path "$Tmp" -DestinationPath "$ParentFolder" -Force
Remove-Item "$Tmp"
Set-Location "$ParentFolder"
.\wsl-terminal-setup-main\Full_Setup.ps1
```

After installation finished, check that ExecutionPolicy is back to Restricted (PowerShell):

```
Get-ExecutionPolicy
```

## Linux:

### Install:

TBD..

```
git clone https://github.com/hasenhuettl/wsl-terminal-setup/tree/main
execute what?
```

# USAGE

For a quickguide on how to use this setup, please see:

https://github.com/hasenhuettl/wsl-terminal-setup/blob/main/Manuals/usage_manual.md

