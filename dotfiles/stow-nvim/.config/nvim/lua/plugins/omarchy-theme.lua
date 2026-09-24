-- Omarchy theme application + hot-reload.
--
-- Omarchy stages the active theme's Neovim spec at
-- ~/.local/state/omarchy/current/theme/neovim.lua and lua/plugins/theme.lua
-- symlinks to it, so lazy's change detector (2s poll, follows symlinks) sees
-- the target swap when the theme is switched, re-imports the spec and fires
-- `User LazyReload`. This plugin reacts to that event -- and applies once at
-- startup -- to switch colorscheme without restarting Neovim.
--
-- The generated spec has the form:
--   { { "<theme plugin>" }, { "LazyVim/LazyVim", opts = { colorscheme = "x" } } }
-- LazyVim is disabled in all-themes.lua; we read the spec ourselves and apply
-- the colorscheme directly.
return {
	{
		name = "omarchy-theme",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 1000,
		config = function()
			-- Every plugin an Omarchy theme may ask to load, keyed by the name
			-- lazy uses for the plugin. Used to drop their cached modules so a
			-- fresh setup() picks up new opts (aether-based themes share the
			-- aether.nvim plugin and only differ by opts).
			local THEME_PLUGIN_KEYS = {
				"aether",
				"bamboo.nvim",
				"ashen.nvim",
				"catppuccin",
				"everforest-nvim",
				"flexoki-neovim",
				"gruvbox.nvim",
				"hackerman.nvim",
				"kanagawa.nvim",
				"lumon.nvim",
				"matteblack.nvim",
				"nightfox.nvim",
				"retro-82.nvim",
				"rose-pine",
				"tokyonight.nvim",
			}

			local Config = require("lazy.core.config")
			local Loader = require("lazy.core.loader")

			local function unload_theme_modules()
				for _, key in ipairs(THEME_PLUGIN_KEYS) do
					local plugin = Config.plugins[key]
					if plugin and plugin.dir then
						require("lazy.core.util").walkmods(plugin.dir .. "/lua", function(modname)
							package.loaded[modname] = nil
							package.preload[modname] = nil
						end)
					end
				end
				-- Always re-read the generated spec, never a cached copy.
				package.loaded["plugins.theme"] = nil
			end

			local function apply_theme()
				local ok, spec = pcall(require, "plugins.theme")
				if not ok then
					return
				end

				local colorscheme, background, theme_spec
				for _, s in ipairs(spec) do
					if s and type(s) == "table" then
						if s[1] == "LazyVim/LazyVim" and s.opts then
							colorscheme = s.opts.colorscheme
							background = s.opts.background
						elseif not theme_spec then
							theme_spec = s
						end
					end
				end
				if not (colorscheme and theme_spec) then
					return
				end

				-- Module name for require()/setup(): spec.name (aether,
				-- catppuccin, rose-pine) or the URL basename stripped of the
				-- .nvim / -nvim / .neovim / -neovim suffix (everforest,
				-- gruvbox, kanagawa, flexoki, ...).
				local url = theme_spec[1]
				local base = url:match("([^/]+)$")
				local modname = theme_spec.name
					or base:gsub("%.nvim$", "")
						:gsub("%-nvim$", "")
						:gsub("%.neovim$", "")
						:gsub("%-neovim$", "")
				local plugin_key = theme_spec.name or base

				-- Resolved opts: raw spec merged with all-themes.lua by lazy.
				local plugin = Config.plugins[plugin_key]
				local merged_opts = plugin and plugin.opts or theme_spec.opts

				unload_theme_modules()

				-- Load the plugin that ships this colorscheme (no-op if the
				-- plugin is already loaded). Installs nothing.
				Loader.colorscheme(colorscheme)

				local ok_mod, mod = pcall(require, modname)
				if ok_mod and type(mod.setup) == "function" then
					pcall(mod.setup, merged_opts or {})
				end

				-- Reset, then let the colorscheme set its own background.
				vim.o.background = "dark"
				if background then
					vim.g[modname .. "_background"] = background
					if background == "light" then
						vim.o.background = "light"
					end
				end

				pcall(vim.cmd.colorscheme, colorscheme)
				vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
				vim.cmd("redraw!")
			end

			-- Fired by lazy's change detector when lua/plugins/* changes.
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyReload",
				callback = function()
					vim.schedule(apply_theme)
				end,
			})

			-- Apply the current theme after startup. Retry a few times in case
			-- the theme plugin is still being installed on first launch.
			-- libuv timers run in a fast event context where getcompletion()
			-- is forbidden, so hop through vim.schedule into the main loop.
			local tries = 0
			local timer = vim.uv.new_timer()
			timer:start(200, 500, function()
				tries = tries + 1
				vim.schedule(function()
					local prev = vim.g.colors_name
					apply_theme()
					if vim.g.colors_name == prev and tries < 20 then
						return -- no change yet; keep waiting
					end
					timer:stop()
					timer:close()
				end)
			end)
		end,
	},
}