-- Vimscript-style autocommands and abbreviations
vim.cmd([[
  " === General Settings ===
  augroup GENERAL_SETTINGS
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd BufWinEnter * set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup END

  " === Git Commit Formatting ===
  augroup GIT
    autocmd!
    autocmd FileType gitcommit setlocal wrap spell
  augroup END

  " === Markdown Formatting ===
  augroup MARKDOWN
    autocmd!
    autocmd FileType markdown setlocal wrap spell
  augroup END

  " === Auto Resize ===
  augroup AUTO_RESIZE
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup END

  " === Alpha Dashboard ===
  augroup ALPHA
    autocmd!
    autocmd User AlphaReady set showtabline=0
    autocmd BufUnload <buffer> set showtabline=2
  augroup END

  " === YAML / Ansible ===
  augroup YAML
    autocmd!
    autocmd BufRead,BufNewFile *.yml,*.yaml set filetype=yaml.ansible
  augroup END

  " === Remove Trailing Whitespace on Save ===
  augroup TRAILING_WHITESPACE
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
  augroup END

  " === Abbreviations ===
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
  iab \textt{ \texttt{
  iab \textttt{ \texttt{

  " === Commands & Abbreviations ===
  command! -nargs=0 Q q
  command! -nargs=0 Wq wq
  cnoreab W w
  cnoreab W! w!
  cmap w!! w !sudo tee % >/dev/null
  command! SaveAsRoot w !sudo tee %

  " === Backup: fallback cursor restore (legacy/compat)===
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]])

-- === Lua Autocommands ===

-- Restore last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.cmd([[silent! normal! g`"zv]])
  end,
})

-- Show notification when opening read-only file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if not vim.bo.modifiable or vim.bo.readonly then
      vim.notify("Opened read-only file: " .. vim.fn.expand("%"), vim.log.levels.WARN, { title = "Read-Only" })
    end
  end,
})

-- Toggle indent-blankline and notify in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if vim.o.paste then vim.cmd("IBLDisable") end
    if vim.bo.readonly then vim.notify("This file is read-only", vim.log.levels.WARN) end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.cmd("IBLEnable")
    vim.cmd("set nopaste number scl=yes")
  end,
})

-- TMUX: Rename window to current file
if os.getenv("TMUX") then
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
      local filename = vim.fn.expand("%:t")
      vim.fn.system("tmux rename-window '" .. filename .. "'")
    end,
  })

  vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    callback = function()
      vim.fn.system("tmux setw automatic-rename")
    end,
  })
end

-- Optional: LSP formatting on save (commented)
-- vim.api.nvim_create_augroup("LSP", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = "LSP",
--   pattern = "*",
--   callback = function()
--     vim.lsp.buf.format({ async = false })
--   end,
-- })

