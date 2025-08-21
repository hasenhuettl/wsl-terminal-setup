# Prompt styling
function parse_git_branch() {
  git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1] /p'
}

# Prompt = text at beginning of terminal line
# Color sheet: https://www.ditig.com/publications/256-colors-cheat-sheet
COLOR_RESET=$'%f'
COLOR_D_RED=$'%F{1}'
COLOR_L_RED=$'%F{9}'
COLOR_PURPLE=$'%F{5}'
COLOR_TEAL=$'%F{6}'
COLOR_PINK=$'%F{13}'
COLOR_L_BLUE=$'%F{14}'

# %n=User, %m=hostname, %3=directory
setopt PROMPT_SUBST
export PROMPT='${COLOR_PURPLE}%n${COLOR_PINK}@${COLOR_TEAL}%m ${COLOR_L_RED}%3~ ${COLOR_L_BLUE}$(parse_git_branch)${COLOR_RESET}$ '

## Echo CTRL+C => ^C
#TRAPINT() {
#  print -Pn "${COLOR_D_RED}^C${COLOR_RESET}"
#  return 128
#}

# Red display for broken symlinks
export LSCOLORS=ExFxBxDxCxegedabagacad
export LS_COLORS="rs=0:di=01;34:ln=01;36:so=01;35:pi=40;33:ex=01;32:bd=40;33;01:cd=40;33;01:mi=01;31:or=01;31:*.txt=01;33"

