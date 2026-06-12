-- Treesitter is provided by Nix (parsers are pre-compiled in the runtimepath).
-- This file just configures it — do NOT add this to lazy specs.
local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then return end

configs.setup({
  -- Parsers are Nix-managed; never auto-install
  ensure_installed = {},
  auto_install = false,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = { enable = true },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection    = "<C-space>",
      node_incremental  = "<C-space>",
      node_decremental  = "<bs>",
      scope_incremental = false,
    },
  },
})
