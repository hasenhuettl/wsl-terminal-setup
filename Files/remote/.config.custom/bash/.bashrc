# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

umask 0002

source $HOME/.config.custom/bash/.bash_profile # Environment variables
source $HOME/.config.custom/bash/start_multiplexer.sh # Open tmux or screen if available

# Fallback: continue with bash
# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

