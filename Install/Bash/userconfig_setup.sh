#!/bin/bash

set -e

FOLDER=$HOME/git/wsl-terminal-setup

# Define files to backup
files=(.bashrc .ssh .config.custom scripts)

cd ~

mkdir -p git
mkdir -p .ssh/cm_socket
mkdir -p .local/data

cd git

if [[ ! -d "$FOLDER" ]]; then
  git clone https://github.com/hasenhuettl/wsl-terminal-setup.git
fi

cd ~

# Check for existing backups first
for file in "${files[@]}"; do
  backup="$file.pre-wsl-terminal-setup"
  if [ -e "$backup" ]; then
    echo "Error: $backup already exists. Aborting to prevent overwrite." >&2
    exit 1
  fi
done

# If file exists, do a backup
for file in "${files[@]}"; do
  if [[ -e "$file" ]]; then
    echo "Moving old $file to $file.pre-wsl-terminal-setup..."
    mv "$file" "$file.pre-wsl-terminal-setup"
  fi
done

# Create symlinks
ln -s "$FOLDER/Files/local/.config.custom" ".config.custom"
ln -s ".config.custom/bash/.bashrc" ".bashrc"
ln -s "git/wsl-terminal-setup/Files/local/scripts" "scripts"

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
