local options = {
  autoindent = true, -- match previous indentation when pressing Enter at EOL
  backup = false, -- create no backup file
  -- clipboard = "unnamedplus", -- share clipboard with windows (as alternative to dragging text via WinTerminal)
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  cursorline = false, -- highlights the current line
  emoji = true, -- Add this only if you use plugins that show icons
  expandtab = true, -- convert tabs to spaces
  fileencoding = "utf-8", -- the encoding written to a file
  guifont = "monospace:h17", -- the font used in graphical neovim applications
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  inccommand = "split", -- Preview what subsitutions will look like
  incsearch = true, -- Incremental search while typing
  list = true, -- enable list for listchars to work
  listchars = { tab = "▸ ", nbsp = "␣", trail = "•", extends = "⟩", precedes = "⟨", }, -- highlight trailing whitespace with a "•" character
  linebreak = true, -- companion to wrap, don't split words
  mouse = "", -- disallow the mouse to be used in neovim
  number = true, -- set numbered lines. !!ALSO CHANGE THIS IN autocommands.lua -> InsertLeave!!
  numberwidth = 4, -- set number column width to 2 {default 4}
  pumheight = 10, -- pop up menu height
  relativenumber = false, -- set relative numbered lines
  scrolloff = 3, -- minimal number of screen lines to keep above and below the cursor
  shiftround = true, -- use multiple of shiftwidth when indenting with '<' and '>'
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  showmode = false, --  set to false if we don't need to see things like -- INSERT -- anymore
  showtabline = 2, -- always show tabs
  sidescrolloff = 8, -- minimal number of screen columns either side of cursor if wrap is `false`
  signcolumn = "yes", -- always show the sign column (otherwise it would shift the text each time). !!ALSO CHANGE THIS IN autocommands.lua -> InsertLeave!!
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  smarttab = true, -- insert tabs on the start of a line according to shiftwidth, not tabstop
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  tabstop = 2, -- insert 2 spaces for a tab
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 300, -- faster completion (4000ms default)
  whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line
  wrap = true, -- display lines as one long line
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- https://seniormars.com/posts/neovim-workflow/
vim.opt.wildmode = "list:longest,list:full" -- for : stuff
-- Ignore the following file suffixes in the tab completion menu
vim.opt.wildignore:append({ ".javac", "node_modules", "*.pyc" })
vim.opt.wildignore:append({ ".aux", ".out", ".toc" }) -- LaTeX
vim.opt.wildignore:append({
  ".o",
  ".obj",
  ".dll",
  ".exe",
  ".so",
  ".a",
  ".lib",
  ".pyc",
  ".pyo",
  ".pyd",
  ".swp",
  ".swo",
  ".class",
  ".DS_Store",
  ".git",
  ".hg",
  ".orig",
})
-- vim.opt.iskeyword:append({ "_", }) -- Considers these characters as part of a word
vim.opt.suffixesadd:append({ ".java", ".rs" }) -- open-these suffixes with gf
-- vim.opt.shortmess = "ilmnrx" -- flags to shorten vim messages, see :help 'shortmess'
vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- separate vim plugins from neovim in case vim still in use

