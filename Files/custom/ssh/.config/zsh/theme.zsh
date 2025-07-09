# Prompt styling
function parse_git_branch() {
  git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1] /p'
}

# Color sheet: https://www.ditig.com/publications/256-colors-cheat-sheet
COLOR_DEF=$'%f'
COLOR_USR=$'%F{5}'
COLOR_ATS=$'%F{13}'
COLOR_SRV=$'%F{6}'
COLOR_DIR=$'%F{9}'
COLOR_GIT=$'%F{14}'

setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n${COLOR_ATS}@${COLOR_SRV}%m ${COLOR_DIR}%3~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}$ '

# Red display for broken symlinks
export LSCOLORS=ExFxBxDxCxegedabagacad
export LS_COLORS="rs=0:di=01;34:ln=01;36:so=01;35:pi=40;33:ex=01;32:bd=40;33;01:cd=40;33;01:mi=01;31:or=01;31:*.txt=01;33"

