#!/bin/bash

set -e

sudo apt update
sudo apt install tmux bash zsh sshpass -y # Terminal handling
sudo apt install tldr wget git gh -y # Useful tools
sudo apt install snapd fzf fd-find ripgrep luarocks -y # Neovim setup
sudo systemctl enable --now snapd.socket

# Wait for snapd to be fully initialized
echo "Waiting for snapd to be ready..."
until snap version &>/dev/null; do
    echo "snapd not ready, waiting 5 seconds..."
    sleep 5
done

# Step 5: Install nvim using snap
echo "snapd is ready, installing nvim..."
sudo snap install nvim --classic

mkdir -p ~/.config
sudo mkdir -p /opt/git
sudo chown $USER:$USER /opt/git
cd /opt/git
git clone https://github.com/hasenhuettl/wsl-terminal-setup.git
ln -s /opt/git/wsl-terminal-setup/Files/custom ~/custom

cd

# Setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sed -i '/export ZSH="\$HOME\/.oh-my-zsh"/i export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST' ~/.zshrc
# Use either custom styling (custom.zsh), or:
sed -i 's/ZSH_THEME="[^"]*"/ZSH_THEME="daveverwer"/' ~/.zshrc

# symlink all !FILES AND SYMLINKS! that start with . in given path to ~/
find /opt/git/wsl-terminal-setup/Files/ -maxdepth 1 -type f,l -name ".*" -exec ln -s {} ~/ \;

rm -rf ~/.oh-my-zsh/custom
# copy all !DIRECTORIES! that start with . in given path to ~/
find /opt/git/wsl-terminal-setup/Files/ -maxdepth 1 -type d -name ".*" -exec cp -a {} ~/ \;

ln -s ~/custom/sshurl.pl /usr/bin/sshurl

# reboot (wsl --shutdown)
# exit
