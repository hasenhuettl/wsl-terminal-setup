-- return {
--   'echasnovski/mini.nvim', version = false,
--   config = function()
--     require('mini.statusline').setup()
--   end
-- }

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local bit = require('bit')

    local function file_status_info()
      if vim.bo.readonly then
        local filename = vim.api.nvim_buf_get_name(0)
        if filename == '' then return '' end

        local stat = vim.loop.fs_stat(filename)
        if not stat then return '' end

        local mode = stat.mode
        local perms = ''
        local flags = {
          { 0x100, 'r' }, { 0x80, 'w' }, { 0x40, 'x' },
          { 0x20, 'r' }, { 0x10, 'w' }, { 0x8, 'x' },
          { 0x4,  'r' }, { 0x2,  'w' }, { 0x1,  'x' },
        }
        for _, f in ipairs(flags) do
          perms = perms .. (bit.band(mode, f[1]) ~= 0 and f[2] or '-')
        end

        local owner = vim.fn.systemlist('id -nu ' .. (stat.uid or 0))[1] or 'unknown'
        local ro_icon = vim.bo.readonly and ' RO' or ''
        return string.format('%s %s %s', ro_icon, owner, perms)
      else
        return ""
      end
    end

    local function readonly_bg_color()
      if vim.bo.readonly then
        return { bg = '#f38ba8', fg = '#1e1e2e', gui = 'bold' }
      else
        return { fg = '#000', gui = 'bold' }
      end
    end

    require("lualine").setup({
      sections = {
        lualine_c = {
          {
            file_status_info,
            color = readonly_bg_color,
          },
          {
            'filename',
            path = 1,
            color = readonly_bg_color,
          },
        },
        lualine_x = {
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = "#ff9e64" },
          },
        },
      },
    })
  end,
}

