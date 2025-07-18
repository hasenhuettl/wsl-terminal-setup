# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# add nvim to PATH
PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export PATH

# Config locations
export CONFIG_LOCATION="$HOME/.config.custom"

if [[ $(hostname) == *-wsl ]]; then
  export TMUX_CONF=$CONFIG_LOCATION/tmux/tmux.conf
  #export TMUX_NESTING="0"
else
  export TMUX_CONF=$CONFIG_LOCATION/tmux/tmux.conf.remote
  #export TMUX_NESTING="1"
fi

screen_conf=$CONFIG_LOCATION/screen/screen.rc
# User specific aliases and functions
mkdir -p "$HOME/.local/data"
mkdir -p "$HOME/.cache/wget"
mkdir -p "$HOME/.cache/zsh"

# export XDG_CONFIG_HOME="$HOME/.config.custom" # Default .config folder where files will be written
# export XDG_CONFIG_DIRS="$HOME/.config.custom:$XDG_CONFIG_DIRS" # Directories where config files will be searched
export HISTFILE="$HOME/.local/data/zsh_history"
export ZDOTDIR="$HOME/.config.custom/zsh" # Change zsh configuration directory (.zshrc, .zshenv, and .zprofile)

# Do not save commands started with a whitespace
export HISTIGNORE=' *'

