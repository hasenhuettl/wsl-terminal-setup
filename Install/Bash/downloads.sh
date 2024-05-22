#!/bin/bash

set -e

sudo apt update
sudo apt install tmux zsh sshpass tldr
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="daveverwer"/' ~/.zshrc
mv ~/.custom.zsh ~/.oh-my-zsh/custom/custom.zsh
source .zshrc
sudo ln -s ~/custom/sshurl.pl /usr/bin/sshurl

# exit