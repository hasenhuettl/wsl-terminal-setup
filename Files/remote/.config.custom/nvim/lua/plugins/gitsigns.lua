return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true, -- ← shows who/when a line was changed
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',  -- 'eol' | 'overlay' | 'right_align'
        delay = 2000,
        ignore_whitespace = false,
      },
      -- current_line_blame_formatter = ' <author>, <author_time:%Y-%m-%d> - <summary>',
      current_line_blame_formatter = ' <author> <author_time:%Y-%m-%d>',
    }
  end
}

