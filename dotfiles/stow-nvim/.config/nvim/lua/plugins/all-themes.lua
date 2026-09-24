-- Pre-install every plugin an Omarchy theme may ask for, without applying any
-- of them. Omarchy stages the active theme's spec at
-- ~/.local/state/omarchy/current/theme/neovim.lua (symlinked into
-- lua/plugins/theme.lua). That generated file references LazyVim to carry its
-- colorscheme opts, so LazyVim is disabled here and the active colorscheme is
-- applied by lua/plugins/omarchy-theme.lua instead.
--
-- List sources:
--  * /usr/share/omarchy/default/themed/neovim.lua.tpl (aether-based themes)
--  * /usr/share/omarchy/themes/*/neovim.lua (single-plugin themes)
return {
	-- Aether is the shared engine for every template-generated theme
	-- (ethereal, last-horizon, lupine, miasma, ristretto, vantablack, white).
	-- Name and branch must match the Omarchy template so the raw spec from
	-- theme.lua and this one merge into a single plugin by URL.
	{
		"bjarneo/aether.nvim",
		branch = "v3",
		name = "aether",
		lazy = true,
		priority = 1000,
	},
	{
		"ribru17/bamboo.nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"ficcdaf/ashen.nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
	},
	{
		"neanias/everforest-nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"kepano/flexoki-neovim",
		lazy = true,
		priority = 1000,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"bjarneo/hackerman.nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"omacom-io/lumon.nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"tahayvr/matteblack.nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"OldJobobo/retro-82.nvim",
		lazy = true,
		priority = 1000,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		priority = 1000,
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
	},
	-- The Omarchy-generated spec wraps its colorscheme in a LazyVim opts table.
	-- This config has no LazyVim, so keep it from being installed.
	{
		"LazyVim/LazyVim",
		enabled = false,
	},
}