-- LSP, Mason, Autocompletion
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Mason for managing servers
      { "williamboman/mason.nvim", config = true },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Completion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "mfussenegger/nvim-lint",
        event = {
          "BufReadPre",
          "BufNewFile",
        },
        config = function()
          local lint = require("lint")

          lint.linters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            svelte = { "eslint_d" },
            python = { "pylint" },
          }

          local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

          vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
              lint.try_lint()
            end,
          })
        end,
      },
    },
    config = function()
      -- List of language servers
      local lsp_servers = {
        "ansiblels",     -- Ansible
        "bashls",        -- Bash
        "dockerls",      -- Dockerfile
        "html",          -- HTML
        "jsonls",        -- JSON
        "ts_ls",         -- JavaScript/TypeScript
        "lua_ls",        -- Lua
        "marksman",      -- Markdown
        "pyright",       -- Python
        "yamlls",        -- YAML
      }

      local lsp_linting_server = {
        "eslint_d",      -- Web dev filetypes
        "pylint",        -- Python
      }

      -- Mason setup
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
      require("mason-tool-installer").setup {
        ensure_installed = lsp_linting_server,
      }
      require("mason-lspconfig").setup {
        ensure_installed = lsp_servers,
        automatic_installation = true,
      }

      -- Completion setup
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- LSP setup
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Loop through servers and apply config
      for _, server in ipairs(lsp_servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
        vim.lsp.enable(server)
      end
    end,
  }
}

