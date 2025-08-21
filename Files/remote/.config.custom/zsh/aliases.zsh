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
alias ls='ls -hF --color=tty' # Differentiate file types via color
alias md='mkdir -p' # No error if directory exists, create parent directories if needed
alias rd='rmdir'

# Text editor
alias vi='\vim -u ~/.config.custom/vim/.myvimrc'
alias vimdiff='vim -d' # Compare files
if hash nvim > /dev/null 2>&1; then
  # Set standard editor to nvim (if its installed)
  alias vim='env XDG_CONFIG_HOME="$HOME/.config.custom" nvim' # run nvim, with config files located in $HOME/.config.custom
  alias svim='sudo env HOME=$HOME XDG_CONFIG_HOME="$HOME/.config.custom" $(which nvim)' # as root, run nvim with my config
elif hash vim > /dev/null 2>&1; then
  # 2nd option: Vim
  alias vim='\vim -u ~/.config.custom/vim/.myvimrc'
  alias svim='sudo env HOME=$HOME vim -u ~/.config.custom/vim/.myvimrc' # as root, run vim with my config
else
  # Else fallback to basic vi
  alias vi='vi'
  alias vim='vi'
  alias svim='sudo vi' # as root, run vi
fi

# Misc
alias _='sudo '
alias egrep='grep -E'
alias fgrep='grep -F'
alias wget='wget --hsts-file=$HOME/.cache/wget/wget-hsts'
alias which-command='whence'
alias install_packages='bash $HOME/.config.custom/scripts/install_packages.sh'
alias brc='vim ~/.config.custom/bash/ && echo "Restart terminal to apply changes"'
alias nrc='vim ~/.config.custom/nvim/lua' # applied after nvim is restarted
alias trc='vim ~/.config.custom/tmux/tmux.conf && tmux source-file $TMUX_CONF'
alias zrc='vim ~/.config.custom/zsh/ && source ~/.config.custom/zsh/.zshrc'

# Git operations
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gpo='git push origin'
alias gl='git pull'
alias gp='git push'
alias gr='git restore'
alias grs='git restore --staged'
alias gfs='git fetch --all --tags'
alias gpr='git pull --rebase'
alias grev='git revert'
alias gsta='git stash push'
alias gstp='git stash pop'

# Git display info
alias gs='git status'
alias gsh='git show'
alias gd='git diff'
alias gds='git diff --staged'
alias gcp='git cherry-pick'
alias gl='git log'
alias glg='git log --graph'
alias gll='git log --oneline'
alias gitk='git log --graph --oneline --decorate --all --color'
alias gitk="git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitkk="git log --all --decorate --oneline --graph"
alias gitstats="git shortlog -sne --no-merges"

# Git branch management
alias gb='git branch'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gcm='git checkout $(git_main_branch)'
alias gsw='git switch'
alias gswc='git switch --create'
alias gtag='git tag'
alias gdel='git branch -D'
alias gm='git merge'
alias ggc='git config --global'

# Functions
if [[ ! -v SSH_CLIENT ]]; then
  alias ssh='$HOME/scripts/myssh.py'
  alias ussh='/usr/bin/ssh'
fi

