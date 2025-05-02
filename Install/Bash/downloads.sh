#!/bin/bash

set -e

sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install tmux bash zsh sshpass -y # Terminal handling
sudo apt installl tldr wget git gh -y # Useful tools
sudo apt install neovim fzf fd-find ripgrep luarocks -y # Neovim setup

mkdir ~/.config
mkdir /git
cd /git
git clone https://github.com/hasenhuettl/wsl-terminal-setup.git
ln -s /git/wsl-terminal-setup/Files/custom ~/custom

# symlink all !FILES! that start with . in given path to ~/
find /git/wsl-terminal-setup/Files/ -maxdepth 1 -type f -name ".*" -exec ln -s {} ~/ \;
ln -s /git/wsl-terminal-setup/Files/.config/nvim .config/nvim
cd

# Setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i '/export ZSH="\$HOME\/.oh-my-zsh"/i export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST' ~/.zshrc
# Use either custom styling (custom.zsh), or:
# sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="daveverwer"/' ~/.zshrc

ln -s ../../.custom.zsh .oh-my-zsh/custom/00_custom.zsh # Alternative: ln -s ~/.custom.zsh ~/.oh-my-zsh/custom/custom.zsh
ln -s ~/custom/sshurl.pl /usr/bin/sshurl

# reboot (wsl --shutdown)
# exit
