umask 0002

# You can change location of zsh files (zcompdump, zdir, etc.) in .bashrc

# History config
HISTSIZE=10000 # How many commands to store in history
SAVEHIST=10000
setopt SHARE_HISTORY # Share history in every terminal session
setopt HIST_IGNORE_SPACE # Exclude commands that start with space from history
setopt HIST_NO_STORE

WORDCHARS='' # Consider these as part of a word (e.g.: / is not in here, so CTRL + Cursor-Right will stop at / )

export GOPATH=$HOME/go

# Set standard editor to nvim (if its installed)
if hash nvim > /dev/null 2>&1; then
  export VISUAL=nvim
  export EDITOR="$VISUAL"
else
  echo "No Neovim here... (•́︵•̀)"
fi

