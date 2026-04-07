return {
  -- Imitate LSP server capabilities with cli tools using none-ls
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      -- Re-create deprecated shellcheck module (does not need npm)
      local shellcheck = {
        name = "shellcheck",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "sh", "bash" },
        generator = null_ls.generator({
          command = "shellcheck",
          args = { "--format", "json", "-" },
          to_stdin = true,
          from_stderr = false,
          format = "json",
          check_exit_code = function(code)
            return code <= 1
          end,
          on_output = function(params)
            local diagnostics = {}
            for _, d in ipairs(params.output or {}) do
              table.insert(diagnostics, {
                row = d.line,
                col = d.column,
                end_row = d.endLine,
                end_col = d.endColumn,
                message = d.message,
                severity = ({
                  error = 1,
                  warning = 2,
                  info = 3,
                  style = 4,
                })[d.level] or 2,
                source = "shellcheck",
                code = d.code,
              })
            end
            return diagnostics
          end,
        }),
      }

      null_ls.setup({
        sources = {
          shellcheck,
          null_ls.builtins.formatting.shfmt,
        },
      })
    end,
  },
}
