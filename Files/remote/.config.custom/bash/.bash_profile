# Path
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

PATH="$PATH:/opt/nvim-linux-x86_64/bin" # add nvim to PATH

export PATH

# Config locations
export CONFIG_LOCATION="$HOME/.config.custom"

# Multiplexer
# if [[ ! -v SSH_CLIENT ]]; then
#   export TMUX_CONF=$CONFIG_LOCATION/tmux/tmux.conf
# else
#   export TMUX_CONF=$CONFIG_LOCATION/tmux/tmux.conf.remote
# fi

screen_conf=$CONFIG_LOCATION/screen/screen.rc

# User specific aliases and functions
mkdir -p "$HOME/.local/data"
mkdir -p "$HOME/.cache/wget"
mkdir -p "$HOME/.cache/zsh"

# export XDG_CONFIG_HOME="$HOME/.config.custom" # Default .config folder where files will be written
# export XDG_CONFIG_DIRS="$HOME/.config.custom:$XDG_CONFIG_DIRS" # Directories where config files will be searched
export HISTFILE="$HOME/.local/data/zsh_history"
export TMUX_CONF=$CONFIG_LOCATION/tmux/tmux.conf
export ZDOTDIR="$HOME/.config.custom/zsh" # Change zsh configuration directory (.zshrc, .zshenv, and .zprofile)
export PYTHON_HISTORY=~/.local/share/python/history # Only takes effect for Python 3.13+

# Do not save commands started with a whitespace
export HISTIGNORE=' *'

