#!/usr/bin/env bash

set -euo pipefail

# Packages
basic_tools=(curl tar)
useful_tools=(wget git)
terminal_handling=(tmux bash zsh rsync)
neovim_dependencies=(fzf fd-find ripgrep luarocks pip shfmt shellcheck)

echoandrun() {
  echo "\$ $*" ;
  "$@" ;
}

# Detect Linux distro
get_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ -n "$ID" ]; then
      echo "$ID"
    else
      echo "unknown"
    fi
  else
    echo "unknown"
  fi
}

install_deps() {
  echo "Checking linux distro..."

  DISTRO=$(get_distro)

  echo "Detected distro: $DISTRO"

  case "$DISTRO" in
    ubuntu | debian)
      echo "System is ubuntu/debian."
      echo "Updating cache..."

      echoandrun sudo apt update

      echo "Installing dependencies..."

      echoandrun sudo apt install -y \
        "${basic_tools[@]}" \
        "${useful_tools[@]}" \
        "${terminal_handling[@]}" \
        "${neovim_dependencies[@]}"

      ;;

    centos | rhel)
      echo "System is centos/rhel."

      echo "Installing dependencies..."

      echoandrun sudo yum install -y \
        "${basic_tools[@]}" \
        "${useful_tools[@]}" \
        "${terminal_handling[@]}" \
        "${neovim_dependencies[@]}"

      ;;

    *)
      echo "Unsupported distro: $DISTRO"
      exit 1
      ;;
  esac

  echo "✅ Successfully installed dependencies."
}

install_neovim() {

  cd ~

  echo "Checking glibc version..."

  # (... ||:) = pipefail fix https://unix.stackexchange.com/questions/582844/how-to-suppress-sigpipe-in-bash/582850#582850
  glibc_version="$(ldd --version | (head -n1 ||:) | awk '{print $NF}')"
  major="$(echo "$glibc_version" | cut -d. -f1)"
  minor="$(echo "$glibc_version" | cut -d. -f2)"

  if [ "$major" -lt 2 ] || { [ "$major" -eq 2 ] && [ "$minor" -lt 34 ]; }; then
    echo "glibc version < 2.34 → using best-effort, unsupported build Neovim from https://github.com/neovim/neovim-releases"
    neovim_url="https://github.com/neovim/neovim-releases/releases/download/stable/nvim-linux-x86_64.tar.gz"
  else
    echo "glibc version >= 2.34 → using latest Neovim release"
    neovim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  fi

  echo "Installing Neovim..."

  curl -LO "$neovim_url"
  echoandrun sudo rm -rf "/opt/nvim-linux-x86_64"
  echoandrun sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  echoandrun rm nvim-linux-x86_64.tar.gz

  echoandrun sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

  echo "✅ Dependencies installed at /opt/nvim-linux-x86_64 and linked to /usr/local/bin/nvim"
  nvim --version

  echo "Sourcing ZSH again..."
  source "$HOME/.config.custom/zsh/.zshrc"
}

main() {
  install_deps
  install_neovim
  echo "✅ Successfully installed Neovim! 🥳"
}

main

