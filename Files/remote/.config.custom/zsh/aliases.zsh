# Git
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit --all'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gcm='git checkout $(git_main_branch)'
alias ggc='git config --global'
alias gitk='git log --graph --oneline --decorate --all --color'
alias gpo='git push origin'
alias gpl='git pull'
alias gp='git push'
alias gr='git remote'
alias grb='git rebase'
alias gfs='git fetch --all --tags'
alias gd='git diff'
alias gds='git diff --staged'
alias gcp='git cherry-pick'
alias gl='git log'
alias glg='git log --graph'
alias gll='git log --oneline'
alias gs='git status'
alias gsta='git stash push'
alias gstp='git stash pop'
alias gsh='git show'
alias gsw='git switch'
alias gswc='git switch --create'
alias gtag='git tag'
alias gdel='git branch -D'
alias gm='git merge'
alias gpr='git pull --rebase'
alias grev='git revert'

# File system navigation
alias -- -='cd -' # Press - to navigate to previous directory (Toggle current/previous dir)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -hF --color=tty'
alias md='mkdir -p'
alias rd='rmdir'

# Text editor
alias vi='vim -u ~/.config.custom/vim/.myvimrc'
if hash nvim > /dev/null 2>&1; then
  # Set standard editor to nvim (if its installed)
  alias vim='env XDG_CONFIG_HOME="$HOME/.config.custom" nvim'
  alias svim='sudo env HOME=$HOME XDG_CONFIG_HOME="$HOME/.config.custom" $(which nvim)' # as root, run nvim with my config
else
  # Else fallback to vim
  alias vim='vim -u ~/.custom.config/vim/.myvimrc'
  alias svim='sudo env HOME=$HOME vim -u ~/.config.custom/vim/.myvimrc' # as root, run vim with my config
fi

# Misc
alias _='sudo '
alias egrep='grep -E'
alias fgrep='grep -F'
alias wget='wget --hsts-file=$HOME/.cache/wget/wget-hsts'
alias which-command='whence'
alias brc='vim ~/.config.custom/bash/ && echo "Restart terminal to apply changes"'
alias nrc='vim ~/.config.custom/nvim/lua' # Open and close neovim
alias trc='vim ~/.config.custom/tmux/ && tmux source-file $TMUX_CONF'
alias zrc='vim ~/.config.custom/zsh/ && source ~/.config.custom/zsh/.zshrc'

# Functions
if [[ $(hostname) == *-wsl ]]; then
  alias ssh='$HOME/scripts/myssh.py'
  alias ussh='/usr/bin/ssh'
fi

