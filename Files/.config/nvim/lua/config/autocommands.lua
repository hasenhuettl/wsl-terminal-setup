vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end

  augroup _yaml
    autocmd!
"    au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
    au BufRead,BufNewFile *.yml set filetype=yaml.ansible
    au BufRead,BufNewFile *.yaml set filetype=yaml.ansible
  augroup end

" Remove trailing whitespaces at end of line when saving
augroup remove_trailing_whitespace
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

]])

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})
-- Check if running inside TMUX
if os.getenv("TMUX") then
  -- Rename TMUX window to the filename on buffer enter
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
      local filename = vim.fn.expand("%:t")
      vim.fn.system("tmux rename-window '" .. filename .. "'")
    end,
  })

  -- Re-enable automatic renaming on exit
  vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    callback = function()
      vim.fn.system("tmux setw automatic-rename")
    end,
  })
end

vim.cmd([[command! -nargs=0 Q q]])
vim.cmd([[command! -nargs=0 Wq wq]])
vim.cmd([[cnoreab W w]])
vim.cmd([[cnoreab W! w!]])
vim.cmd([[cmap w!! w !sudo tee % >/dev/null]])
vim.cmd([[command! SaveAsRoot w !sudo tee %]])

-- Jump to last edited position in the file
vim.api.nvim_command([[au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])

-- Autoformat
-- augroup _lsp
--   autocmd!
--   autocmd BufWritePre * lua vim.lsp.buf.formatting()
-- augroup end

vim.cmd([[
iab sychron synchron
iab snychro synchro
iab nihct nicht
iab Dtaen Daten
iab gitb gibt
iab teh the
iab Teh The
iab taht that
iab Taht That
iab tehre there
iab Tehre There
iab tihs this
iab Tihs This
iab tohse those
iab Tohse Those
iab waht what
iab Waht What
iab tehn then
iab Tehn Then
iab Tehse These
iab tehse these
iab nciht nicht
iab Nciht Nicht
iab udn und
iab Udn Und
iab bruacht braucht
iab Bruacht Braucht
iab keien keine
iab Keien Keine
iab histroy history
iab neccessary necessary
iab neccesary necessary
iab necesary necessary


" In case I type one fewer t when using \texttt in LaTeX documents
iab \textt{ \texttt{
iab textttt{ texttt{
]])
