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

# Set standard editor to nvim (if its installed)
if hash nvim > /dev/null 2>&1; then
  export VISUAL=nvim
  export EDITOR="$VISUAL"
else
  echo "No Neovim here... You can install it via 'install_packages' command."
fi

# Tab completion
# Enable the menu-completion widget for interactive selection (Press tab twice to show a menu)
zstyle ':completion:*' menu select=2

# Use fuzzy matching (e.g., typing only part of a word)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{A-Z}={a-z}'

# Additional completion enhancements for speed
zstyle ':completion:*' verbose false

