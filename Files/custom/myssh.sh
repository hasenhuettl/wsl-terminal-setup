#!/usr/bin/zsh
echo "$*"

#set -x

ENABLE_LOGGING=false

host="${@: -1}"
printf '\033k%s\033\\' "$host"
date=$(date "+%Y.%m.%d-%H.%M.%S")
mkdir -p ~/log

ssh_auto () {
  local format_pass
  local format_extra
  format_pass=""
  format_extra=""
  if [ -n "$SSHPASS" ] ; then
    #/usr/bin/ssh -O check "$@" || format_pass="sshpass -e "
    format_pass="sshpass -e "
  fi
  for ((i = 1; i <= $#; i++ )); do
    format_extra=$(builtin printf "%s %s" "${format_extra}" "%q")
  done

  # Check if logging is enabled
  if [ "${ENABLE_LOGGING}" = "true" ]; then
    script -q -a --command "$(builtin printf "${format_pass}ssh${format_extra}" "$@" )" "/home/${USER}/log/$date-$host"
  else
    eval "$(builtin printf "${format_pass}ssh${format_extra}" "$@" )"
  fi
}

no_multi_session () {
  echo "No ControlMaster"
  ssh_auto -o "ControlMaster=no" -t "$@"
  ret=$?

  if [ "${ENABLE_LOGGING}" = "true" ]; then
    xz "/home/${USER}/log/$date-$host"
    echo "closing in 2 seconds"
    sleep 2
  fi

  exit $ret
}

ssh_auto -f -N "$@"
#pid=$!
#while ( kill -0 $pid && ! ssh -O check "$@" 2>/dev/null ) ; do
while (  ! ssh -O check "$@" 2>/dev/null ) ; do
##sleep 1
echo -n
done
ssh_auto "$@" uptime
sleep 1
ssh -O check "$@" || no_multi_session "$@"

# Define local and remote directories
skel="$HOME/custom/ssh"

# Check if more than one argument is passed
if [ $# -gt 1 ]; then
  rarg=$(echo "${@: 1: -1}")

  rsync -rEtLvze "ssh $rarg" "$skel/" "$host:" || read
else
  rsync -rEtLvz "$skel/" "$host:" || read
fi

#tmux set-option -s status-interval 1
ssh_auto "$@" "tmux -V" && tmux set-option  -w '@fwdmouse' 1
ssh_auto -t "$@" ./.mysshrc
ret=$?
tmux set-option  -w '@fwdmouse' ''
#kill $pid
/usr/bin/ssh -O exit "$@"

if [ "${ENABLE_LOGGING}" = "true" ]; then
  xz "/home/${USER}/log/$date-$host"
  echo "closing in 2 seconds"
  sleep 2
fi

exit $ret

