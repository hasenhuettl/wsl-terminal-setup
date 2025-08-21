# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source ~/.config.custom/zsh/options.zsh # import zsh options
source ~/.config.custom/zsh/aliases.zsh # import aliases
source ~/.config.custom/zsh/bindkeys.zsh # import bindkeys
source ~/.config.custom/zsh/theme.zsh # import theme and styling
source ~/.config.custom/zsh/plugins/* # place plugin files (plugin.zsh) here

source ~/.config.custom/zsh/custom.zsh # Use this to add custom configs (file is .gitignored)

