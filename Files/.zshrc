umask 0002

# import aliases
source .zshrc.aliases

# custom config
source .zshrc.local

# add nvim to PATH
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

bindkey "^[[1;5C" forward-word # CTRL + cursor-right
bindkey "^[[1;5D" backward-word # CTRL + cursor-left
bindkey "^[[1~" delete-char
bindkey "^[[3~" delete-char

# Bind Shift-Left/Right to no terminal input
bindkey -s '^[[1;2C' ''
bindkey -s '^[[1;2D' ''

function parse_git_branch() {
  git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1] /p'
}

# PROMPT styling: Refer to: https://www.ditig.com/publications/256-colors-cheat-sheet
COLOR_DEF=$'%f'
COLOR_USR=$'%F{5}'
COLOR_ATS=$'%F{13}'
COLOR_SRV=$'%F{6}'
COLOR_DIR=$'%F{9}'
COLOR_GIT=$'%F{14}'
setopt PROMPT_SUBST

export PROMPT='${COLOR_USR}%n${COLOR_ATS}@${COLOR_SRV}%m ${COLOR_DIR}%3~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}$ '

export HISTIGNORE=' *'
export GOPATH=$HOME/go

if [[ $(hostname) == *-wsl ]]; then
  alias ssh=~/custom/myssh.sh
  alias ussh=/usr/bin/ssh
fi

