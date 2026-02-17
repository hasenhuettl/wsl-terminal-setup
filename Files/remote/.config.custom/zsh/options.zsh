umask 0002

# You can change location of zsh files (zcompdump, zdir, etc.) in .bashrc

# History config
HISTSIZE=10000 # How many commands to store in history
SAVEHIST=10000
setopt SHARE_HISTORY # Share history in every terminal session
setopt HIST_IGNORE_SPACE # Exclude commands that start with space from history
setopt HIST_NO_STORE # Don't store history (fc -l) command

WORDCHARS='' # Consider these as part of a word (e.g.: / is not in here, so CTRL + Cursor-Right will stop at / )

export GOPATH=$HOME/go # Default since Go 1.8

# Save Windows Home directory path in linux format (/mnt/c/Users/$USER)
if [ -n "$WSL_DISTRO_NAME" ]; then
  export WINHOME=$(wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")
fi

# Set standard editor to nvim (if its installed)
if hash nvim > /dev/null 2>&1; then
  export SUDO_EDITOR="$HOME/.config.custom/scripts/open_nvim.sh"
  export VISUAL="$SUDO_EDITOR"
  export EDITOR="$SUDO_EDITOR"
else
  echo "No Neovim here... You can install it via 'install_packages' command. (RHEL: sudo dnf module reset nodejs && sudo dnf module enable nodejs:20 && install_packages)"
fi

# Tab completion
# Enable the menu-completion widget for interactive selection (Press tab twice to show a menu)
zstyle ':completion:*' menu select=2

# Use fuzzy matching (e.g., typing only part of a word)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{A-Z}={a-z}'

# Additional completion enhancements for speed
zstyle ':completion:*' verbose false

