#!/usr/bin/env bash

set -euo pipefail

# Packages
basic_tools="curl tar"
useful_tools="wget git"
terminal_handling="tmux bash zsh rsync"
neovim_dependencies="fzf fd-find ripgrep luarocks"
neovim_dependencies_lsp="nodejs"
#neovim_dependencies_lsp="nodejs python3-venv"
nodejs_min_version=18

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

check_nodejs_version() {
  local NODE_MAJOR=$1

  if [ "$NODE_MAJOR" -ge "$nodejs_min_version" ]; then
    return 0 # success
  else
    return 1 # error
  fi
}

install_deps() {
  echo "Checking linux distro..."

  DISTRO=$(get_distro)
  NODE_OK=false

  echo "Detected distro: $DISTRO"

  case "$DISTRO" in
    ubuntu | debian)
      echo "System is ubuntu/debian."
      echo "Updating cache..."

      echoandrun sudo apt update

      echo "Checking available nodejs version..."

      NODE_CANDIDATE="$(apt-cache policy nodejs | grep Candidate | awk '{print $2}')"

      if [ -n "$NODE_CANDIDATE" ] && [ "$NODE_CANDIDATE" != "(none)" ]; then
        NODE_MAJOR=$(echo "$NODE_CANDIDATE" | cut -d. -f1)
        if check_nodejs_version $NODE_MAJOR; then
          NODE_OK=true
        else
          echo "⚠️ Node.js $NODE_CANDIDATE lower than $nodejs_min_version. Skipping node & language server installation."
        fi
      else
        echo "⚠️ Node.js is not available in apt repositories."
      fi

      echo "Installing dependencies..."

      echoandrun sudo apt install -y \
        $basic_tools \
        $useful_tools \
        $terminal_handling \
        $neovim_dependencies

      if [ "$NODE_OK" = true ]; then
        echoandrun sudo apt install -y $neovim_dependencies_lsp
        echo "✅ Successfully installed node & language server!"
      else
        echo "Skipped node & language server."
      fi
      ;;

    centos | rhel)
      echo "System is centos/rhel."
      echo "Checking available nodejs version..."

      NODE_CANDIDATE="$(yum info nodejs 2>/dev/null | grep Version | awk '{print $3}')"

      if [ -n "$NODE_CANDIDATE" ]; then
        NODE_MAJOR=$(echo "$NODE_CANDIDATE" | cut -d. -f1)
        if check_nodejs_version $NODE_MAJOR; then
          NODE_OK=true
        else
          echo "⚠️ Node.js $NODE_CANDIDATE lower than $nodejs_min_version. Skipping node & language server installation."
        fi
      else
        echo "⚠️ Node.js is not available in yum repositories."
      fi

      echo "Installing dependencies..."

      echoandrun sudo yum install -y \
        $basic_tools \
        $useful_tools \
        $terminal_handling \
        $neovim_dependencies

      if [ "$NODE_OK" = true ]; then
        echoandrun sudo yum install -y $neovim_dependencies_lsp
        echo "✅ Successfully installed node & language server!"
      else
        echo "Skipped node & language server."
      fi
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
    echo "glibc version < 2.34 → using Neovim v0.11.2"
    neovim_url="https://github.com/neovim/neovim-releases/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz"
  else
    echo "glibc version >= 2.34 → using latest Neovim release"
    neovim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  fi

  echo "Installing Neovim..."

  curl -LO "$neovim_url"
  echoandrun sudo rm -rf /opt/nvim
  echoandrun sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  echoandrun rm nvim-linux-x86_64.tar.gz

  echoandrun sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

  echo "✅ Dependencies installed at /opt/nvim-linux-x86_64 and linked to /usr/local/bin/nvim"
  nvim --version
}

main() {
  install_deps
  install_neovim
  echo "✅ Successfully installed Neovim! 🥳"
}

main

