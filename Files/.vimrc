syntax on
set nocompatible
set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set number
set hlsearch

if exists('$TMUX')
    autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux setw automatic-rename")
endif