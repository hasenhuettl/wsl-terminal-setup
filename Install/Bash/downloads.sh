#!/bin/bash

set -e

sudo apt update
sudo apt install tmux bash zsh sshpass -y # Terminal handling
sudo apt installl tldr wget git gh -y # Useful tools
sudo apt install snapd fzf fd-find ripgrep luarocks -y # Neovim setup
sudo systemctl enable --now snapd.socket
sudo snap install nvim

mkdir ~/.config
sudo mkdir /opt/git
sudo chown $USER:$USER /opt/git
cd /opt/git
git clone https://github.com/hasenhuettl/wsl-terminal-setup.git
ln -s /opt/git/wsl-terminal-setup/Files/custom ~/custom

cd

# symlink all !FILES AND SYMLINKS! that start with . in given path to ~/
find /opt/git/wsl-terminal-setup/Files/ -maxdepth 1 -type f,l -name ".*" -exec ln -s {} ~/ \;
# copy all !DIRECTORIES! that start with . in given path to ~/
find /opt/git/wsl-terminal-setup/Files/ -maxdepth 1 -type d -name ".*" -exec cp -a {} ~/ \;

# Setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i '/export ZSH="\$HOME\/.oh-my-zsh"/i export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST' ~/.zshrc
# Use either custom styling (custom.zsh), or:
sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="daveverwer"/' ~/.zshrc

ln -s ~/custom/sshurl.pl /usr/bin/sshurl

# reboot (wsl --shutdown)
# exit
