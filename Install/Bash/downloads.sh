#!/bin/bash

set -e

FOLDER=$HOME/git/wsl-terminal-setup

cd ~

source $FOLDER/Install/Bash/install_packages.sh

mkdir -p git
mkdir -p .ssh/cm_socket
mkdir -p .local/data

cd git

if [[ ! -d "$FOLDER" ]]; then
  git clone https://github.com/hasenhuettl/wsl-terminal-setup.git
fi

cd ~

# Backup old files
# Check for .bashrc backup
if [ -e ".bashrc.pre-wsl-terminal-setup" ]; then
  echo "Error: .bashrc.pre-wsl-terminal-setup already exists. Aborting to prevent overwrite." >&2
  exit 1
fi

# Check for .ssh backup
if [ -e ".ssh.pre-wsl-terminal-setup" ]; then
  echo "Error: .ssh.pre-wsl-terminal-setup already exists. Aborting to prevent overwrite." >&2
  exit 1
fi

[ -e ".config.custom" ] && mv ".config.custom" ".config.custom.pre-wsl-terminal-setup"
[ -e ".bashrc" ] && mv ".bashrc" ".bashrc.pre-wsl-terminal-setup"
[ -e ".ssh" ] && mv ".ssh" ".ssh.pre-wsl-terminal-setup"

# Create symlinks
ln -s "$FOLDER/Files/local/.config.custom" ".config.custom"
ln -s ".config.custom/bash/.bashrc" ".bashrc"

# TODO:
# sudo ln -sf "$HOME/custom/sshurl.pl" "/usr/bin/sshurl"

# Copy ssh config
cp -r "$FOLDER/Files/local/.ssh" ".ssh"

# Copy .custom.zsh from template (if not exists)
[ ! -e .config.custom/zsh/custom.zsh ] && cp .config.custom/zsh/.custom.zsh.template .config.custom/zsh/custom.zsh

# Ask for reboot
BLUE='\033[0;34m'
NC='\033[0m' # No Color
printf "${BLUE}The system ($HOSTNAME) may require a reboot. Do you want to reboot now?${NC} (y/n): "
read -n 1 response
printf "\n"

if [[ "$response" =~ ^[Yy]$ ]]; then
  # Function to check if the system is WSL
  is_wsl() {
    grep -qE "(Microsoft|WSL)" /proc/version
  }

  # If system is WSL, shutdown WSL
  if is_wsl; then
    echo "Detected WSL. Shutting down WSL..."
    cmd.exe /C wsl --shutdown
  else
    echo "Rebooting system..."
    sudo reboot
  fi
else
  echo "Reboot canceled."
fi
