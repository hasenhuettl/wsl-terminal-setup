# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source $CONFIG_LOCATION/zsh/plugins/* # place plugin files (e.g.: plugin.zsh) in this directory

source $CONFIG_LOCATION/zsh/options.zsh
source $CONFIG_LOCATION/zsh/aliases.zsh
source $CONFIG_LOCATION/zsh/bindkeys.zsh
source $CONFIG_LOCATION/zsh/theme.zsh

source $CONFIG_LOCATION/zsh/custom.zsh # Use this to add custom configs (file is .gitignored)

if $enable_holidays; then
  source $CONFIG_LOCATION/zsh/holidays.zsh
fi

