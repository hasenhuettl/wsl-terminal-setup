umask 0002

# History config
HISTFILE=~/.zsh_history # History file for zsh
HISTSIZE=10000 # How many commands to store in history
SAVEHIST=10000
setopt SHARE_HISTORY # Share history in every terminal session
setopt HIST_IGNORE_SPACE # Exclude commands that start with space from history
setopt HIST_NO_STORE

WORDCHARS='_' # Consider these as part of a word (e.g.: / is not in here, so CTRL + Cursor-Right will stop at / )

export GOPATH=$HOME/go

# Set editor to nvim
export VISUAL=nvim
export EDITOR="$VISUAL"

