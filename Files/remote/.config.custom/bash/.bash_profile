# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

export PATH

# User specific aliases and functions
mkdir -p "$HOME/.local/data"
mkdir -p "$HOME/.cache/wget"

# Zsh config
# export XDG_CONFIG_HOME="$HOME/.config.custom" # Default .config folder where files will be written
# export XDG_CONFIG_DIRS="$HOME/.config.custom:$XDG_CONFIG_DIRS" # Directories where config files will be searched
export ZCOMPDUMP="$HOME/.cache/zsh/.zcompdump"
export ZDIRS="$HOME/.cache/zsh/.zdirs"
export HISTFILE="$HOME/.local/data/zsh_history"
export ZDOTDIR="$HOME/.config.custom/zsh" # Change zsh configuration directory (.zshrc, .zshenv, and .zprofile)

# Do not save commands started with a whitespace
export HISTIGNORE=' *'

