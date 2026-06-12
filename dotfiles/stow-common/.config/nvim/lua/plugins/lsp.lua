-- LSP plugin (lua config only) — server *executables* are provided by Nix in PATH.
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("gd",         vim.lsp.buf.definition,   "Go to definition")
        map("gD",         vim.lsp.buf.declaration,  "Go to declaration")
        map("gr",         vim.lsp.buf.references,   "Go to references")
        map("gI",         vim.lsp.buf.implementation, "Go to implementation")
        map("K",          vim.lsp.buf.hover,         "Hover docs")
        map("<leader>la", vim.lsp.buf.code_action,   "Code action")
        map("<leader>lr", vim.lsp.buf.rename,         "Rename")
        map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
      end

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { prefix = "●" },
        float = { border = "rounded" },
      })

      -- Each server binary is provided by Nix — just configure them here.
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
        nil_ls  = {},
        pyright = {},
        ts_ls   = {},
        gopls   = {},
        rust_analyzer = {},
      }

      for name, cfg in pairs(servers) do
        cfg.capabilities = capabilities
        cfg.on_attach    = on_attach
        lspconfig[name].setup(cfg)
      end
    end,
  },
}
