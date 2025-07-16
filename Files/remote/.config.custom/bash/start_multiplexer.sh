#!/bin/bash

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
  exec tmux -f $TMUX_CONF new-session -A
}

# Main
if hash tmux 2> /dev/null; then
  start_tmux # Start tmux (if available)
elif type screen > /dev/null; then
  start_screen # Start tmux (if available)
fi

