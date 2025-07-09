#!/bin/bash

set -e

cd ~

sudo apt update
sudo apt install tmux bash zsh sshpass -y # Terminal handling
sudo apt install tldr wget git gh -y # Useful tools
sudo apt install fzf fd-find ripgrep luarocks -y # Neovim dependencies

# Install nvim using pre-built binary
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
# For RHEL 8 / older glibc version:
# curl -LO https://github.com/neovim/neovim-releases/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

mkdir -p .config
mkdir -p git

cd git
FOLDER=~/git/wsl-terminal-setup

if [ ! -d "$FOLDER" ] ; then
  git clone https://github.com/hasenhuettl/wsl-terminal-setup.git
fi

ln -s $FOLDER/Files/custom ~/custom

cd ~

# symlink all !FILES AND SYMLINKS! that start with . in given path to ~/
find $FOLDER/Files/ -maxdepth 1 -type f,l -name ".*" -exec ln -s {} ~/ \;

# copy all !DIRECTORIES! that start with . in given path to ~/
find $FOLDER/Files/ -maxdepth 1 -type d -name ".*" -exec cp -a {} ~/ \;

sudo ln -s ~/custom/sshurl.pl /usr/bin/sshurl

if [ ! -f ~/.config/zsh/custom.zsh ]; then
  cp ~/.config/zsh/custom.zsh.template ~/.config/zsh/custom.zsh
fi

# reboot, or on WSL open cmd and execute: wsl --shutdown
# exit

