#!/bin/bash

set -e

sudo apt update
sudo apt install tmux zsh sshpass tldr gh -y

mkdir /git
cd /git
git clone https://github.com/hasenhuettl/wsl-terminal-setup.git
ln -s /git/wsl-terminal-setup/Files/custom ~/custom
ln -s /git/wsl-terminal-setup/Files/.* ~/
cd

# Setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i '/export ZSH="\$HOME\/.oh-my-zsh"/i export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST' ~/.zshrc
sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="daveverwer"/' ~/.zshrc

ln -s .custom.zsh .oh-my-zsh/custom/00_custom.zsh
ln -s ~/custom/sshurl.pl /usr/bin/sshurl

# reboot (wsl --shutdown)
# exit