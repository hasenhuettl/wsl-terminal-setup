#!/usr/bin/env bash

set -euo pipefail

# Packages
basic_tools="curl tar"
useful_tools="wget git gh"
terminal_handling="tmux bash zsh rsync"
neovim_dependencies="fzf fd-find ripgrep luarocks"

# Detect Linux distro
get_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  else
    echo "unknown"
  fi
}

DISTRO=$(get_distro)

echo "Detected distro: $DISTRO"

install_deps() {
  echo "Installing dependencies..."
  echo $basic_tools
  echo $useful_tools

  case "$DISTRO" in
    ubuntu | debian)
      sudo apt update
      sudo apt install -y \
        $basic_tools \
        $useful_tools \
        $terminal_handling \
        $neovim_dependencies
      ;;

    centos | rhel)
      sudo yum install -y \
        $basic_tools \
        $useful_tools \
        $terminal_handling \
        $neovim_dependencies
      ;;

    *)
      echo "Unsupported distro: $DISTRO"
      exit 1
      ;;
  esac
}

install_neovim() {
  echo "Checking glibc version..."
  glibc_version=$(ldd --version | head -n1 | awk '{print $NF}')
  major=$(echo "$glibc_version" | cut -d. -f1)
  minor=$(echo "$glibc_version" | cut -d. -f2)

  if [ "$major" -lt 2 ] || { [ "$major" -eq 2 ] && [ "$minor" -lt 34 ]; }; then
    echo "glibc version < 2.34 → using Neovim v0.11.2"
    neovim_url="https://github.com/neovim/neovim-releases/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz"
  else
    echo "glibc version >= 2.34 → using latest Neovim release"
    neovim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  fi

  curl -LO "$neovim_url"
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm nvim-linux-x86_64.tar.gz

  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

  echo "✅ Dependencies installed at /opt/nvim and linked to /usr/local/bin/nvim"
  nvim --version
}

main() {
  install_deps
  install_neovim
}

main

