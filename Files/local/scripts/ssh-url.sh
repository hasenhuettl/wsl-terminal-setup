#!/bin/bash

SESSION="$USER@$(hostname -s)"
HOST="$1"

# Remove ssh:// prefix if present
HOST=${HOST#ssh://}
# Remove trailing / if present
HOST=${HOST%/}

# Check if user is already specified in the HOST (user@host format)
if [[ $HOST == *@* ]]; then
  # User already specified, use as-is
  SSH_TARGET="$HOST"
  echo "Using specified user from URL"
else
  # No user specified, prompt for one
  echo "Connect as:"
  echo "1) Local user ($USER)"
  echo "2) Root"
  echo "3) Custom user"
  read -n1 -p "Select (1-3): " choice
  echo  # Print newline after single character input

  case $choice in
    1)
      SSH_USER="$USER"
      ;;
    2)
      SSH_USER="root"
      ;;
    3)
      read -p "Enter username: " SSH_USER
      ;;
    *)
      echo "Invalid choice"
      exit 1
      ;;
  esac

  SSH_TARGET="${SSH_USER}@${HOST}"
fi

COMMAND="cd; $HOME/scripts/myssh.py ${SSH_TARGET}; exec zsh"

tmux has-session -t "$SESSION"
returnValue=$?

if [[ $returnValue -eq 0 ]]; then
  # Session exists
  echo "Attaching new tmux window to existing tmux.."
  tmux new-window -t "$SESSION" "$COMMAND"
else
  echo "Please open WSL first."
  #tmux -f $TMUX_CONF new-session -s "$SESSION" && exit
fi

