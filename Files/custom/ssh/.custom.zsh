umask 0002

alias ls='ls -hF --color=tty'
alias vi="vim -u ~/.myvimrc"

alias repo="cd /var/www/html/git/dev/prototypes/"
alias gits="git status"
alias gitk="git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitkk="git log --all --decorate --oneline --graph"
alias gitstats="git shortlog -sne --no-merges"
alias ussh=/usr/bin/ssh

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char

function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1] /p'
}

# Refer to: https://www.ditig.com/publications/256-colors-cheat-sheet
COLOR_DEF=$'%f'
COLOR_USR=$'%F{183}'
COLOR_ATS=$'%F{146}'
COLOR_SRV=$'%F{87}'
COLOR_DIR=$'%F{197}'
COLOR_GIT=$'%F{39}'
setopt PROMPT_SUBST

export PROMPT='${COLOR_USR}%n${COLOR_ATS}@${COLOR_SRV}%m ${COLOR_DIR}%3~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}$ '

export HISTIGNORE=' *'

export GOPATH=$HOME/go
