#!/bin/bash

set -e

sudo apt update
sudo apt install tmux bash zsh sshpass -y # Terminal handling
sudo apt install tldr wget git gh -y # Useful tools
sudo apt install fzf fd-find ripgrep luarocks -y # Neovim dependencies

# # Install nvim using snap
# sudo apt install snapd
# sudo systemctl enable --now snapd.socket
#
# # Wait for snapd to be fully initialized
# echo "Waiting for snapd to be ready..."
# until snap version &>/dev/null; do
#     echo "snapd not ready, waiting 5 seconds..."
#     sleep 5
# done
#
# echo "snapd is ready, installing nvim..."
# sudo snap install nvim --classic

# Install nvim using flatpak
sudo apt install flatpak -y
flatpak install flathub io.neovim.nvim -y

cd ~
mkdir -p .config
sudo mkdir -p git
cd git

FOLDER=~/git/wsl-terminal-setup

if [ ! -d "$FOLDER" ] ; then
  git clone https://github.com/hasenhuettl/wsl-terminal-setup.git
fi

ln -s $FOLDER/Files/custom ~/custom

cd

# Setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i '/export ZSH="\$HOME\/.oh-my-zsh"/i export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST' ~/.zshrc
# Use either custom styling (custom.zsh), or:
sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="daveverwer"/' ~/.zshrc

# symlink all !FILES AND SYMLINKS! that start with . in given path to ~/
find $FOLDER/Files/ -maxdepth 1 -type f,l -name ".*" -exec ln -s {} ~/ \;

rm -rf ~/.oh-my-zsh/custom
# copy all !DIRECTORIES! that start with . in given path to ~/
find $FOLDER/Files/ -maxdepth 1 -type d -name ".*" -exec cp -a {} ~/ \;

sudo ln -s ~/custom/sshurl.pl /usr/bin/sshurl

# reboot, or on WSL open cmd and execute: wsl --shutdown
# exit

