return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    -- Color scheme
    vim.cmd[[colorscheme catppuccin-latte]]

    -- Try enabling this in case of issues? Think it sets the background if its not defined by terminal?
    -- vim.opt.background = "light"

    -- -- Make diagnostic underlines squiggly and colorful!
    -- vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "Red" })
    -- vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = "Orange" })
    -- vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { undercurl = true, sp = "LightBlue" })
    -- vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { undercurl = true, sp = "LightGrey" })
  end,
}

-- Alternative: tokyonight
--return {
--  "folke/tokyonight.nvim",
--  lazy = false,
--  priority = 1000,
--  --opts = {},
--  opts = {
--    transparent_background = true,
--  },
--  config = function()
--    vim.cmd[[colorscheme tokyonight-day]]
--  end
--}
