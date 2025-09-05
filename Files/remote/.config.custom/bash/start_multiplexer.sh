#!/bin/bash

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Functions
start_screen () {
  which zsh 2>&1 > /dev/null && echo "shell zsh" >> "$screen_conf"
  if [ -d "/usr/share/lib/terminfo/t" ] ; then
    cp .terminfo/t/* /usr/share/lib/terminfo/t
  fi
  list=($(screen -ls | awk '/[0-9]+\.pt/ {print $1}') )
  if [ "${#list[@]}" -gt 0 ] ; then
    PS3='Please enter your choice: '
    list+=('new session')
    select opt in "${list[@]}"
    do
      case "$opt" in
          "new session")
              exec screen -c $screen_conf
              break
              ;;
          *)
            exec screen -x "$opt" -c $screen_conf
            ;;
      esac
    done
  else
    exec screen -c $screen_conf
  fi
}

start_tmux () {
  # Only run if session is interactive, and not already inside tmux (Safeguard for infinite shell opening loop)
  if [[ -z "$TMUX" ]]; then
    exec tmux -f $TMUX_CONF new-session -A -s "$USER@$(hostname -s)"
  else
    echo "Tried to start tmux, but tmux is already running..."
  fi
}

# ===========================
# ==== MAIN
# ===========================
# Start tmux (if available)
if hash tmux 2> /dev/null; then
  start_tmux
# Else, start screen (if available)
elif hash screen 2> /dev/null; then
  start_screen # Start tmux (if available)
fi
# Else, do nothing

