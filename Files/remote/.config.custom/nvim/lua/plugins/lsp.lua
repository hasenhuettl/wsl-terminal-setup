return {
  -- Diagflow
  {
    "dgagn/diagflow.nvim",
    event = "LspAttach",
    opts = {
      toggle_event = { "InsertEnter", "InsertLeave" }, -- disable error checks during edit mode
      scope = 'line', -- 'cursor', or 'line'
      placement = 'top', -- 'top', 'inline'
      show_borders = true, -- disable this for placement 'inline'
    },
    config = function(_, opts)
      local diagflow = require("diagflow")
      diagflow.setup(opts)

    end,
  },
  -- LSP server config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Mason
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "superhtml",
          "quick_lint_js",
          "ty",
          "marksman",
          "lua_ls",
        },
      })

      -- Minimal handlers
      local servers = {
        "superhtml",
        "quick_lint_js",
        "ty",
        "marksman",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {})
        vim.lsp.enable(server)
      end

      -- Lua
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- Linters
      require("mason-registry").get_package("shellcheck"):install()

    end,
  },
}

