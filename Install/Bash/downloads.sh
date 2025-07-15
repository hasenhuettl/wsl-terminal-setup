#!/bin/bash

set -e

FOLDER=$HOME/git/wsl-terminal-setup

cd ~

sudo apt update
sudo apt install tmux bash zsh -y # Terminal handling
sudo apt install tldr wget git gh -y # Useful tools
sudo apt install fzf fd-find ripgrep luarocks -y # Neovim dependencies

# Install nvim using pre-built binary
# Check the glibc version
glibc_version=$(ldd --version | head -n 1 | awk '{print $NF}')
major_glibc_version=$(echo $glibc_version | cut -d. -f1)
minor_glibc_version=$(echo $glibc_version | cut -d. -f2)

# Determine the appropriate download link based on glibc version
if [ "$major_glibc_version" -lt 2 ] || { [ "$major_glibc_version" -eq 2 ] && [ "$minor_glibc_version" -lt 34 ]; }; then
  echo "glibc version is lower than 2.34. Using older Neovim release. (11.2)"
  neovim_url="https://github.com/neovim/neovim-releases/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz"
else
  echo "glibc version is 2.34 or higher. Using latest Neovim release. (check last updated: July 2025)"
  neovim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
fi

curl -LO $neovim_url
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

mkdir -p git
mkdir -p .ssh/cm_socket
mkdir -p .local/data

cd git

if [[ ! -d "$FOLDER" ]]; then
  git clone https://github.com/hasenhuettl/wsl-terminal-setup.git
fi

cd ~

# Backup old files
[ -e ".bashrc" ] && mv ".bashrc" ".bashrc.pre-wsl-terminal-setup"
[ -e ".ssh" ] && mv ".ssh" ".ssh.pre-wsl-terminal-setup"

# Create symlinks
ln -sf "$FOLDER/Files/local/.config.custom" ".config.custom"
ln -s ".config.custom/bash/.bashrc" ".bashrc"

# TODO:
# sudo ln -sf "$HOME/custom/sshurl.pl" "/usr/bin/sshurl"

# Copy ssh config
cp -r "$FOLDER/Files/local/.ssh" ".ssh"

# Copy .custom.zsh from template (if not exists)
[ ! -e .config.custom/zsh/custom.zsh ] && cp .config.custom/zsh/.custom.zsh.template .config.custom/zsh/custom.zsh

# Ask for reboot
echo "The system may require a reboot. Do you want to reboot now? (y/n): "
read -n 1 response

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
  echo "Reboot aborted."
fi
