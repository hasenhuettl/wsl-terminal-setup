#!/bin/bash

set -e

sudo apt update
sudo apt install tmux zsh sshpass tldr -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="daveverwer"/' ~/.zshrc
sudo ln -s ~/custom/ssh/.custom.zsh ~/.oh-my-zsh/custom/custom.zsh
sudo ln -s ~/custom/sshurl.pl /usr/bin/sshurl

# reboot (wsl --shutdown)
# exit