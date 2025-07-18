# Key bindings for history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[0A' history-substring-search-up
bindkey '^[0B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Terminal word navigation
bindkey "^[[1;5C" forward-word # CTRL + Cursor-Right
bindkey "^[[1;5D" backward-word # CTRL + Cursor-Left
bindkey "^[[1;3D" backward-kill-word # ALT + Cursor-Left
bindkey "^[^?"    backward-kill-word # ALT + BACKSPACE
bindkey "^[[1;3C" kill-word # ALT + Cursor-Right
bindkey "^[[3;3~" kill-word # ALT + ENTF

# Bind Shift-Left/Right to no terminal input
bindkey -s '^[[1;2C' ''
bindkey -s '^[[1;2D' ''

# Issue: ALT + umlaut inserts <ffffffff>, with this rebind it annoys us with a beep instead
bindkey -s "^[ä" ''
bindkey -s "^[ö" ''
bindkey -s "^[ü" ''

# Let SPACE expand history expressions like !!, !$, etc.
bindkey ' ' magic-space

