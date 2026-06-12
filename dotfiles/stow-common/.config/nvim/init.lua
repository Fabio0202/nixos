vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fix nvim-notify transparent bg warning: set highlight before any plugin loads
vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })
	end,
})

local windows = vim.fn.has("win32") == 1 and require("os.windows") or nil
if windows then
	windows.setup_env()
end
local linux = vim.fn.has("unix") == 1 and not windows and require("os.linux") or nil

-- Clean up stale ShaDa tmp files on startup (prevents E138)
local shada_dir = vim.fn.stdpath("data") .. "/shada"
for name, type in vim.fs.dir(shada_dir) do
	if type == "file" and name:match("^main%.shada%.tmp%.") then
		os.remove(shada_dir .. "/" .. name)
	end
end

-- Diagnostics — nerd font signs, virtual_text off (tiny-inline-diagnostic handles it)
vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Floating windows (rename prompt, hover, etc.) get a border in Neovim 0.11+
vim.o.winborder = "rounded"

-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Defer clipboard init: Windows clipboard detection blocks startup for 200-500ms
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.laststatus = 3 -- global statusline (one bar across all windows)
vim.opt.cmdheight = 0
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Re-emit cursor shape when terminal regains focus (fixes thin-line cursor after alt-tab)
vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		local mode = vim.api.nvim_get_mode().mode
		if mode == "n" or mode == "no" or mode == "v" or mode == "V" then
			vim.opt.guicursor = vim.opt.guicursor
		end
	end,
})

-- Enable treesitter highlighting for all filetypes that have a parser
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

--------------------------------------------------------------------------------
-- Keybindings
--------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>fp", function()
	vim.system({ "zoxide", "query", "-l" }, { text = true }, function(out)
		if out.code ~= 0 or not out.stdout then
			return
		end
		local items = {}
		for line in out.stdout:gmatch("[^\n]+") do
			if vim.uv.fs_stat(line .. "/.git") then
				local name = line:gsub("\\", "/"):match("([^/]+)$")
				table.insert(items, { text = name .. " " .. line, dir = line, name = name })
			end
		end
		vim.schedule(function()
			Snacks.picker.pick({
				source = "Projects",
				items = items,
				format = function(item, _picker)
					local ret = {}
					table.insert(ret, { item.name, "SnacksPickerLabel" })
					table.insert(ret, { "  " .. item.dir, "SnacksPickerComment" })
					return ret
				end,
				confirm = function(picker, item)
					picker:close()
					if not item then
						return
					end
					vim.cmd.cd(item.dir)
					vim.notify("Switched to " .. item.name, vim.log.levels.INFO)
					Snacks.picker.files()
				end,
			})
		end)
	end)
end, { desc = "Find project (zoxide)" })

vim.keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
vim.keymap.set("n", "\\", "<cmd>split<cr>", { desc = "Horizontal split" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right pane" })
vim.keymap.set("n", "<A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
vim.keymap.set("n", "<A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })
vim.keymap.set("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
vim.keymap.set("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Increase height" })
vim.keymap.set("n", "<S-l>", function()
	local els = require("bufferline").get_elements().elements
	if els[#els] and els[#els].id ~= vim.api.nvim_get_current_buf() then
		vim.cmd("BufferLineCycleNext")
	end
end, { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", function()
	local els = require("bufferline").get_elements().elements
	if els[1] and els[1].id ~= vim.api.nvim_get_current_buf() then
		vim.cmd("BufferLineCyclePrev")
	end
end, { desc = "Previous buffer" })

--------------------------------------------------------------------------------
-- Bootstrap lazy.nvim
--------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------

require("lazy").setup({

	-- Catppuccin colorscheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				telescope = { enabled = true },
				which_key = true,
				treesitter = true,
				indent_blankline = { enabled = true },
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	-- Better UI (cmdline, messages, etc.)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		config = function()
			vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#000000" })
			require("notify").setup({ background_colour = "#000000" })
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					lsp_doc_border = true,
				},
			})
		end,
	},

	-- Dashboard (startup screen)
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					week_header = { enable = true },
					shortcut = {
						{
							desc = "󱑇 [f]iles",
							group = "Label",
							action = function()
								Snacks.picker.files()
							end,
							key = "f",
						},
						{
							desc = " [g]rep",
							group = "Number",
							action = function()
								Snacks.picker.grep()
							end,
							key = "g",
						},
						{
							desc = " [q]uit",
							group = "String",
							action = "qa",
							key = "q",
						},
					},
				},
			})
		end,
	},

	-- Trouble (diagnostics / references / quickfix panel)
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>gt",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Toggle Trouble",
			},
			{
				"<leader>gT",
				"<cmd>Trouble todo toggle<cr>",
				desc = "Toggle TODOs (Trouble)",
			},
			{
				"<leader>dd",
				"<cmd>Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR<cr>",
				desc = "Buffer Errors",
			},
			{
				"<leader>dw",
				"<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
				desc = "Workspace Errors",
			},
		},
		opts = {},
	},

	-- Todo-comments (highlight TODO/FIXME/HACK/etc, integrates with Trouble)
	{
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- Oil (file explorer – floating)
	{
		"stevearc/oil.nvim",
		lazy = true,
		keys = {
			{
				"<leader>e",
				function()
					require("oil").toggle_float()
				end,
				desc = "Toggle Oil explorer",
			},
		},
		cmd = "Oil",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				delete_to_trash = false,
				skip_confirm_for_simple_edits = true,
				view_options = { show_hidden = true },
				lsp_file_methods = {
					timeout_ms = 2500,
					autosave_changes = true,
				},
				float = {
					max_width = 40,
					max_height = 40,
					border = "rounded",
					win_options = { winblend = 10 },
					override = function(conf)
						conf.row = 3
						conf.col = 8
						return conf
					end,
				},
				keymaps = {
					["<C-c>"] = "actions.close",
					["q"] = "actions.close",
					["<BS>"] = "actions.parent",
					["|"] = "actions.select_vsplit",
					["\\"] = "actions.select_split",
				},
			})
		end,
	},

	-- Neo-tree (git status panel on the right)
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"d00h/neo-tree-harpoon2.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "<leader>n", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree (git)" },
		},
		opts = {
			close_if_last_window = true,
			sources = { "git_status", "harpoon" },
			source_selector = {
				winbar = true,
				content_layout = "center",
				sources = {
					{ source = "git_status", display_name = " Git" },
					{ source = "harpoon", display_name = "󰛢 Marks" },
				},
			},
			default_view = "git_status",
			default_component_configs = {
				indent = { padding = 0, indent_size = 1 },
				git_status = {
					symbols = {
						added = "",
						deleted = "",
						modified = "",
						renamed = "󰁕",
						untracked = "?",
						ignored = "◌",
						unstaged = "✗",
						staged = "✓",
						conflict = "",
					},
				},
			},
			window = {
				position = "right",
				width = 30,
				mappings = {
					["<space>"] = false,
					-- suppress default mappings that require missing plugins
					["P"] = false,
					["x"] = false,
					-- cycle between Git / Marks tabs
					["<Tab>"] = "next_source",
					["<S-Tab>"] = "prev_source",
					["A"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
					["gg"] = "git_commit_and_push",
				},
			},
			filesystem = {
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			harpoon = {
				-- The harpoon root node uses id=-1 (a number), which crashes neo-tree's
				-- diagnostics renderer. Provide a minimal renderer that skips it.
				renderers = {
					directory = { { "name" } },
					file = { { "icon" }, { "name" } },
				},
				window = {
					mappings = {
						["<cr>"] = "open",
						["d"] = "delete",
						["K"] = "swap_prev",
						["J"] = "swap_next",
						["<Tab>"] = "next_source",
						["<S-Tab>"] = "prev_source",
					},
				},
			},
		},
	},

	-- Snacks (utility: picker, vim.ui.select/input, etc.)
	{
		"folke/snacks.nvim",
		event = "VeryLazy",
		opts = {
			picker = { enabled = true },
			input = { enabled = true },
			select = { enabled = true },
		},
		keys = {
			{ "<leader><leader>", function() Snacks.picker.files() end, desc = "Find files" },
			{ "<leader>ff",       function() Snacks.picker.files() end, desc = "Find files" },
			{ "<leader>fg",       function() Snacks.picker.grep() end,  desc = "Live grep" },
			{ "<leader>fw",       function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
		},
	},

	-- Which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		version = "*",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Buffer pick" },
			{ "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
			{ "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
		},
		config = function()
			require("bufferline").setup()
		end,
	},

	-- Bufdelete (smart close: keeps window, switches to alt buffer)
	{
		"famiu/bufdelete.nvim",
		keys = {
			{ "<leader>x", "<cmd>Bdelete<cr>", desc = "Close buffer" },
		},
	},

	-- Rainbow delimiters (bracket colorization, requires treesitter)
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "BufRead",
		config = function()
			require("rainbow-delimiters.setup").setup({
				condition = function(bufnr)
					-- oil:// buffers have no treesitter parser; skip them
					return not vim.api.nvim_buf_get_name(bufnr):match("^oil://")
				end,
				query = {
					-- liquid has no built-in rainbow query; map it to the generic one
					liquid = "rainbow-delimiters",
				},
			})
		end,
	},

	-- Auto-pairs (insert closing bracket/quote automatically)
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true, -- use treesitter to avoid pairing inside strings/comments
			})
		end,
	},

	-- Indent guides (dim static lines for all levels)
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		main = "ibl",
		opts = {
			indent = { char = "│" },
			scope = { enabled = false }, -- mini.indentscope draws the active scope
		},
	},

	-- Active scope indicator (animated line on current indent block)
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = "BufReadPost",
		config = function()
			require("mini.indentscope").setup({
				symbol = "│",
				options = { try_as_border = true },
				draw = { animation = require("mini.indentscope").gen_animation.none() },
			})
		end,
	},

	-- Render markdown inline (headings, bullets, code blocks, etc.)
	{
		"OXY2DEV/markview.nvim",
		ft = { "markdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {},
	},

	-- Checkmate (interactive markdown checkboxes)
	{
		"bngarren/checkmate.nvim",
		ft = "markdown",
		opts = {
			files = { "*.md" },
			style = false,
		},
	},

	-- Supermaven (AI code completion)
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<C-s>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
				ignore_filetypes = {},
				disable_inline_completion = false,
			})
			vim.keymap.set("n", "<leader>sm", "<cmd>SupermavenToggle<cr>", { desc = "Toggle Supermaven" })
		end,
	},

	-- VimWiki (personal wiki / notes)
	{
		"vimwiki/vimwiki",
		ft = { "vimwiki" },
		cmd = { "VimwikiIndex", "VimwikiDiaryIndex", "VimwikiMakeDiaryNote" },
		keys = { { "<leader>ww", "<cmd>VimwikiIndex<cr>", desc = "Wiki index" } },
		init = function()
			vim.g.vimwiki_list = {
				{
					path = "~/vimwiki/",
					syntax = "markdown",
					ext = ".md",
				},
			}
			vim.g.vimwiki_global_ext = 0 -- don't treat all .md as vimwiki
			-- Use markdown treesitter parser for vimwiki buffers (avoids crash in
			-- markview.nvim's BufEnter handler before the filetype changes below)
			vim.treesitter.language.register("markdown", "vimwiki")
			-- Force vimwiki buffers to markdown filetype so render-markdown & checkmate work
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "vimwiki",
				callback = function(ev)
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(ev.buf) then
							vim.bo[ev.buf].filetype = "markdown"
						end
					end)
				end,
			})
		end,
	},

	-- Harpoon 2 (quick-file bookmarks)
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>a", desc = "Harpoon add file" },
			{ "<leader>hh", desc = "Harpoon quick menu" },
			{ "<leader>1", desc = "Harpoon file 1" },
			{ "<leader>2", desc = "Harpoon file 2" },
			{ "<leader>3", desc = "Harpoon file 3" },
			{ "<leader>4", desc = "Harpoon file 4" },
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Harpoon add file" })
			vim.keymap.set("n", "<leader>hh", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon quick menu" })
			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end, { desc = "Harpoon file 1" })
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end, { desc = "Harpoon file 2" })
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end, { desc = "Harpoon file 3" })
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end, { desc = "Harpoon file 4" })
		end,
	},

	-- Conform (formatter + format-on-save)
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
					less = { "prettier" },
					html = { "prettier" },
					liquid = { "prettier" },
				},
				-- notify_on_error = false: prettier-plugin-liquid can't parse all valid Liquid
				-- (e.g. dynamic capture names inside {% liquid %} blocks). Silent skip is better
				-- than an error popup on every save.
				notify_on_error = false,
				format_on_save = { timeout_ms = 2000, lsp_fallback = true },
				formatters = windows and {
					prettier = windows.prettier_formatter_spec(),
				} or nil,
			})
		end,
	},

	-- Leap (fast navigation with s/S) — moved to Codeberg
	{
		url = "https://codeberg.org/andyg/leap.nvim",
		name = "leap.nvim",
		event = "VeryLazy",
		config = function()
			require("leap").opts.case_sensitive = false
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { silent = true })
			vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { silent = true })
		end,
	},

	-- clever-f (case-insensitive f/F/t/T)
	{
		"rhysd/clever-f.vim",
		event = "VeryLazy",
		init = function()
			vim.g.clever_f_smart_case = 1
		end,
	},

	-- Twilight (dim code outside current context)
	{
		"folke/twilight.nvim",
		lazy = true,
		opts = {
			context = -1, -- highlight only the current function/block
			treesitter = true,
		},
	},

	-- Zen Mode (distraction-free editing)
	{
		"folke/zen-mode.nvim",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
		},
		opts = {
			plugins = {
				twilight = { enabled = true },
			},
		},
	},

	-- Better escape (jj → Esc in insert mode)
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup({
				timeout = vim.o.timeoutlen,
				default_mappings = false,
				mappings = {
					i = { j = { j = "<Esc>" } },
					c = { j = { j = "<Esc>" } },
				},
			})
		end,
	},

	-- Tiny inline diagnostics (prettier virtual text with icons + borders)
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		config = function()
			require("tiny-inline-diagnostic").setup({
				options = {
					use_icons_from_diagnostic = true,
					show_source = false,
					-- only render the bubble on the line the cursor is on
					multilines = {
						enabled = true,
						always_show = false, -- false = only show on cursor line
					},
					show_all_diags_on_cursorline = true,
				},
			})
		end,
	},

	-- Highlight undo/redo changes
	{
		"tzachar/highlight-undo.nvim",
		event = "VeryLazy",
		config = function()
			require("highlight-undo").setup({
				duration = 200,
				undo = { hlgroup = "HighlightUndo", mode = "n", lhs = "u", map = "undo" },
				redo = { hlgroup = "HighlightUndo", mode = "n", lhs = "<C-r>", map = "redo" },
				highlight_for_count = true,
			})
		end,
	},

	-- Undo tree visualizer
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
		},
	},

	-- Gitsigns (git gutter + keybinds)
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			local gs = require("gitsigns")
			gs.setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "󰍵" },
					topdelete = { text = "‾" },
					changedelete = { text = "󱗜" },
					untracked = { text = "│" },
				},
				signcolumn = true,
				linehl = false,
			})

			-- Git keybinds
			local k = vim.keymap.set
			k("n", "<leader>gb", function()
				gs.blame_line()
			end, { desc = " [b]lame" })
			k("n", "<leader>gv", function()
				gs.preview_hunk()
			end, { desc = " [v]iew hunk" })
			k("n", "<leader>gh", function()
				gs.stage_hunk()
			end, { desc = " [h]unk stage" })
			k("n", "<leader>ga", function()
				gs.stage_buffer()
			end, { desc = " stage buffer" })
			k("n", "<leader>gu", function()
				gs.undo_stage_hunk()
			end, { desc = " [u]nstage hunk" })
			k("n", "<leader>grh", function()
				gs.reset_hunk()
			end, { desc = " [r]eset [h]unk" })
			k("n", "<leader>grb", function()
				gs.reset_buffer()
			end, { desc = " [r]eset [b]uffer" })
			k("n", "<leader>gD", function()
				gs.diffthis()
			end, { desc = " [D]iff this" })
			k("n", "]g", function()
				gs.next_hunk()
			end, { desc = "Next git hunk" })
			k("n", "[g", function()
				gs.prev_hunk()
			end, { desc = "Prev git hunk" })

			-- Register which-key group label when which-key is available
			vim.schedule(function()
				local ok, wk = pcall(require, "which-key")
				if ok then
					wk.add({ { "<leader>g", group = " [g]it" } })
				end
			end)
		end,
	},

	-- OmniSharp extended handlers (goto-def on decompiled/metadata files)
	{ "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },

	-- DAP: debugging protocol client + UI (nvim-dap-view) + .NET adapter.
	-- Binaries (netcoredbg on Linux via Nix, Mason on Windows) must be on PATH.
	{
		"mfussenegger/nvim-dap",
		dependencies = { "igorlfs/nvim-dap-view" },
		lazy = true,
		keys = {
			{ "<leader>Dc", function() require("dap").continue() end,         desc = "DAP: Continue / Start" },
			{ "<leader>Do", function() require("dap").step_over() end,        desc = "DAP: Step Over" },
			{ "<leader>Di", function() require("dap").step_into() end,        desc = "DAP: Step Into" },
			{ "<leader>DO", function() require("dap").step_out() end,         desc = "DAP: Step Out" },
			{ "<leader>Db", function() require("dap").toggle_breakpoint() end,desc = "DAP: Toggle Breakpoint" },
			{ "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP: Conditional Breakpoint" },
			{ "<leader>Dt", function() require("dap").terminate() end,        desc = "DAP: Terminate" },
			{ "<leader>Dr", function() require("dap").repl.toggle() end,      desc = "DAP: Toggle REPL" },
			{ "<leader>Du", function() require("dap-view").toggle() end,      desc = "DAP: Toggle dap-view" },
			{ "<leader>Dw", "<cmd>DapViewWatch<cr>",                          desc = "DAP: Watch expression" },
			{ "<leader>Dh", "<cmd>DapViewHover<cr>",                          desc = "DAP: Hover variable" },
			{ "<leader>De", function() require("dap.ext.vscode").load() end,  desc = "DAP: Load launch.json" },
		},
		config = function()
			local dap = require("dap")
			local dv = require("dap-view")

			dv.setup({
				-- Auto-open dap-view when a session starts, auto-close when all end.
				-- Keeps the terminal window after exit so output isn't lost instantly.
				auto_toggle = "keep_terminal",
				winbar = {
					show = true,
					sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
					default_section = "scopes",
					show_keymap_hints = true,
					controls = { enabled = true },
				},
				windows = {
					size = 0.30,
					position = "below",
					terminal = { size = 0.40, position = "right" },
				},
			})

			-- nvim-dap jump behavior: don't steal focus from a visible window,
			-- reuse any tab showing the buffer, else open a new tab.
			dap.defaults.fallback.switchbuf = "usevisible,usetab,newtab"

			-- coreclr adapter — netcoredbg speaks the VS Code debug protocol.
			-- Binary comes from nixpkgs (Linux) or Mason (Windows).
			dap.adapters.coreclr = {
				type = "executable",
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}

			-- Find the built .dll for a .NET project under cwd.
			-- Looks for bin/Debug/<tfm>/<projectname>.dll, preferring the
			-- project whose name matches a sibling .csproj. Returns the path
			-- (string) or nil; the caller (nvim-dap) handles nil as "abort".
			local function find_dotnet_dll()
				local cwd = vim.fn.getcwd()
				local dlls = vim.fn.glob(cwd .. "/bin/Debug/**/*.dll", false, true)
				if #dlls == 0 then
					return nil
				end
				-- Match dll stem to a .csproj name (e.g. MyApp.csproj → MyApp.dll).
				local csproj = vim.fn.glob(cwd .. "/*.csproj", false, true)
				local stem
				if csproj[1] then
					stem = vim.fn.fnamemodify(csproj[1], ":t:r")
				end
				local best
				for _, p in ipairs(dlls) do
					local name = vim.fn.fnamemodify(p, ":t:r")
					if stem and name == stem then
						return p
					end
					-- Skip framework assemblies; remember first project-looking dll.
					if not best and not name:match("^System%.") and not name:match("^Microsoft%.") then
						best = p
					end
				end
				return best or dlls[1]
			end

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "Launch (netcoredbg)",
					request = "launch",
					-- If a single candidate is found, launch without prompting.
					-- Otherwise fall back to a file picker seeded at bin/Debug.
					program = function()
						local detected = find_dotnet_dll()
						if detected then
							return detected
						end
						local cwd = vim.fn.getcwd()
						local picked = vim.fn.input("Path to .dll: ", cwd .. "/bin/Debug/", "file")
						return picked ~= "" and picked or nil
					end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				-- integratedTerminal: route program stdio through a nvim terminal buffer.
				-- Required for console apps that use Console.ReadKey / WindowHeight / etc.
				-- (internalConsole = no real terminal → those calls throw → instant crash)
				console = "integratedTerminal",
				},
				{
					type = "coreclr",
					name = "Attach (netcoredbg)",
					request = "attach",
					processId = function()
						local pid = vim.fn.input("Process ID to attach: ")
						return pid ~= "" and tonumber(pid) or nil
					end,
				},
			}

			-- Breakpoint sign icons (match the rest of the config's nerd-font style)
			vim.fn.sign_define("DapBreakpoint",          { text = "", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DiagnosticWarn"  })
			vim.fn.sign_define("DapBreakpointRejected",  { text = "", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapStopped",             { text = "", texthl = "DiagnosticOk"    })

			-- Register which-key group label
			vim.schedule(function()
				local ok, wk = pcall(require, "which-key")
				if ok then
					wk.add({ { "<leader>D", group = " [D]ebug (DAP)" } })
				end
			end)
		end,
	},

	-- blink.cmp (completion — replaces nvim-cmp)
	{
		"Saghen/blink.cmp",
		lazy = false,
		version = "1.*",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("blink.cmp").setup({
				keymap = {
					preset = "none",
					["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
					["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
					["<C-j>"] = { "select_next", "fallback" },
					["<C-k>"] = { "select_prev", "fallback" },
					["<C-d>"] = { "scroll_documentation_down", "fallback" },
					["<C-f>"] = { "accept", "fallback" },
					["<C-l>"] = { "snippet_forward", "fallback" },
					["<C-h>"] = { "snippet_backward", "fallback" },
				},
				snippets = { preset = "luasnip" },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					per_filetype = {
						markdown = { "lsp" },
						vimwiki = { "lsp" },
					},
				},
				appearance = { nerd_font_variant = "mono" },
				completion = {
					documentation = { auto_show = true, auto_show_delay_ms = 200 },
					menu = { auto_show_delay_ms = 300 },
				},
			})
		end,
	},

	-- CodeDiff (VSCode-style side-by-side / inline diff with git integration)
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		keys = {
			{ "<leader>de", "<cmd>CodeDiff<cr>", desc = "Diff explorer (git status)" },
			{ "<leader>dh", "<cmd>CodeDiff history<cr>", desc = "Diff history (commits)" },
			{ "<leader>df", "<cmd>CodeDiff file HEAD<cr>", desc = "Diff current file vs HEAD" },
			{ "<leader>dm", "<cmd>CodeDiff merge %<cr>", desc = "Diff merge conflicts" },
		},
		opts = {
			layout = "side-by-side",
			jump_to_first_change = true,
			compute_moves = true,
		},
	},

	-- Lualine (statusline)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
		event = "VeryLazy",
		config = function()
			local C = {
				rosewater = "#f5e0dc", flamingo = "#f2cdcd", pink = "#f5c2e7",
				mauve = "#cba6f7", red = "#f38ba8", maroon = "#eba0ac",
				peach = "#fab387", yellow = "#f9e2af", green = "#a6e3a1",
				teal = "#94e2d5", blue = "#89b4fa", sky = "#89dceb",
				lavender = "#b4befe", text = "#cdd6f4", subtext0 = "#a6adc8",
				overlay0 = "#6c7086", surface2 = "#585b70", surface1 = "#45475a",
				surface0 = "#313244", base = "#1e1e2e", mantle = "#181825",
				crust = "#11111b",
			}

			local mode_icons = {
				n = "(ಠ_ಠ)", i = "(◠‿◠)", v = "(ʘ‿ʘ)", V = "(ʘ‿ʘ)",
				["\22"] = "(ʘ‿ʘ)", c = "(°ʖ°)", no = "",
				s = "(¬‿¬)", S = "", ["\19"] = "", ic = "",
				R = "律", Rv = "律", cv = "", ce = "",
				r = "", rm = "", ["r?"] = "", ["!"] = "ﲵ", t = "",
			}

			local mode_color = {
				n = C.red, i = C.teal, v = C.mauve, ["\22"] = C.mauve,
				V = C.red, c = C.yellow, no = C.red, s = C.yellow,
				S = C.yellow, ["\19"] = C.yellow, ic = C.yellow,
				R = C.green, Rv = C.purple, cv = C.red, ce = C.red,
				r = C.cyan, rm = C.cyan, ["r?"] = C.cyan, ["!"] = C.red, t = C.peach,
			}

			local function space()
				return " "
			end

			local function get_lsp_names()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients == 0 then return "󰒓  No servers" end
				local names = vim.tbl_map(function(c) return c.name end, clients)
				return "󰒓  " .. table.concat(names, ", ")
			end

			require("lualine").setup({
				options = {
					theme = "catppuccin",
					globalstatus = true,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
					disabled_filetypes = { statusline = { "dashboard" } },
				},
				sections = {
					lualine_a = {
						{ space, color = { bg = "none", fg = C.blue } },
					},
					lualine_b = {
						{
							function()
								local mode = vim.fn.mode()
								return mode_icons[mode] or mode
							end,
							color = function()
								return { bg = mode_color[vim.fn.mode()] or C.blue, fg = C.mantle, gui = "bold" }
							end,
							separator = { left = "", right = "" },
						},
						{ space, color = { bg = "none", fg = C.blue } },
					},
					lualine_c = {
						{
							"filename",
							path = 1,
							color = { bg = C.blue, fg = C.mantle, gui = "bold" },
							separator = { left = "", right = "" },
							symbols = { modified = " ●", readonly = " 󰌾", unnamed = "󰡯 [No Name]" },
						},
						{
							"filetype",
							icons_enabled = true,
							color = { bg = C.surface0, fg = C.blue, gui = "italic,bold" },
							separator = { left = "", right = "" },
						},
						{ space, color = { bg = "none", fg = C.blue } },
						{
							"branch",
							icon = "",
							color = { bg = C.green, fg = C.mantle, gui = "bold" },
							separator = { left = "", right = "" },
						},
						{
							"diff",
							color = { bg = "none", fg = C.text, gui = "bold" },
							separator = { left = "", right = "" },
							symbols = { added = " ", modified = " ", removed = " " },
							diff_color = {
								added = { fg = C.green },
								modified = { fg = C.yellow },
								removed = { fg = C.red },
							},
						},
						{ space, color = { bg = "none", fg = C.blue } },
					},
					lualine_x = {
						{ space, color = { bg = "none", fg = C.blue } },
					},
					lualine_y = {
						{ space, color = { bg = "none", fg = C.blue } },
					},
					lualine_z = {
						{
							"location",
							color = { bg = C.yellow, fg = C.mantle, gui = "bold" },
							separator = { left = "", right = "" },
						},
						{ space, color = { bg = "none", fg = C.blue } },
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							symbols = { error = " ", warn = " ", info = " ", hint = " " },
							diagnostics_color = {
								error = { fg = C.red },
								warn = { fg = C.yellow },
								info = { fg = C.mauve },
								hint = { fg = C.teal },
							},
							color = { bg = C.surface0, fg = C.blue, gui = "bold" },
							separator = { left = "" },
						},
						{
							get_lsp_names,
							separator = { left = "", right = "" },
							color = { bg = C.mauve, fg = C.mantle, gui = "italic,bold" },
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},

	windows and windows.lazy_specs() or {},
})

--------------------------------------------------------------------------------
-- LSP (native vim.lsp – Neovim 0.11+)
--------------------------------------------------------------------------------

-- blink.cmp is lazy=false so it's available immediately after lazy.setup()
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

if windows then
	windows.setup_lsps()
elseif linux then
	linux.setup_lsps()
end

--------------------------------------------------------------------------------
-- Floating terminal toggle (shared factory)
--------------------------------------------------------------------------------

local function make_float_term(cmd)
	local buf, win = nil, nil
	return function()
		-- Close if already open
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, false)
			win = nil
			return
		end
		-- Fresh buffer if previous terminal exited
		if not buf or not vim.api.nvim_buf_is_valid(buf) then
			buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_create_autocmd("TermClose", {
				buffer = buf,
				once = true,
				callback = function()
					buf = nil
				end,
			})
		end
		local W = math.floor(vim.o.columns * 0.85)
		local H = math.floor(vim.o.lines * 0.85)
		win = vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			width = W,
			height = H,
			col = math.floor((vim.o.columns - W) / 2),
			row = math.floor((vim.o.lines - H) / 2),
			border = "rounded",
			style = "minimal",
		})
		if vim.bo[buf].buftype ~= "terminal" then
			if cmd then
				vim.fn.termopen(cmd)
			else
				vim.cmd("terminal")
			end
		end
		vim.cmd("startinsert")
	end
end

vim.keymap.set("n", "<leader>t", make_float_term(nil), { desc = "Toggle floating terminal" })
vim.keymap.set("n", "<leader>jj", make_float_term("jjui"), { desc = "Toggle jjui" })
-- Exit terminal insert mode with Esc
-- Exit terminal insert mode, then close the float with q or <leader>t
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.keymap.set("n", "q", function()
			vim.api.nvim_win_close(0, false)
		end, { buffer = true, desc = "Close terminal" })
	end,
})

--------------------------------------------------------------------------------
-- LSP keybinds
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- VimWiki utilities
--------------------------------------------------------------------------------

-- Visual: extract selected text into a new wiki note, replace with [[link]]
local function vimwiki_extract_note()
	local sl = vim.fn.getpos("'<")
	local el = vim.fn.getpos("'>")
	-- Clamp end col to line length ('> col is 2147483647 for end-of-line)
	local line = vim.api.nvim_buf_get_lines(0, el[2] - 1, el[2], false)[1] or ""
	local end_col = math.min(el[3], #line)
	local parts = vim.api.nvim_buf_get_text(0, sl[2] - 1, sl[3] - 1, el[2] - 1, end_col, {})
	local title = vim.trim(table.concat(parts, " "))
	if title == "" then
		return
	end

	-- Replace selection with [[title]]
	vim.api.nvim_buf_set_text(0, sl[2] - 1, sl[3] - 1, el[2] - 1, end_col, { "[[" .. title .. "]]" })

	-- Create the note file if it doesn't exist
	local filepath = vim.fn.expand("~/vimwiki/") .. title .. ".md"
	if vim.fn.filereadable(filepath) == 0 then
		local f = io.open(filepath, "w")
		if f then
			f:write("# " .. title .. "\n\n")
			f:close()
			vim.notify("Created: " .. title .. ".md", vim.log.levels.INFO)
		end
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "vimwiki",
	callback = function()
		local wiki = vim.fn.expand("~/vimwiki/")
		vim.keymap.set("v", "<leader>wn", vimwiki_extract_note, { buffer = true, desc = "Wiki: extract to new note" })
		vim.keymap.set("n", "<leader>wf", function()
			Snacks.picker.files({ cwd = wiki })
		end, { buffer = true, desc = "Wiki: find notes" })
		vim.keymap.set("n", "<leader>wg", function()
			vim.ui.input({ prompt = "Wiki grep: " }, function(query)
				if not query or query == "" then
					return
				end
				vim.cmd("grep! " .. vim.fn.shellescape(query) .. " " .. vim.fn.shellescape(wiki))
				vim.cmd("copen")
			end)
		end, { buffer = true, desc = "Wiki: grep notes" })
		vim.keymap.set("n", "<leader>wt", function()
			-- rg is on PATH (VS Code bundled); results land in quickfix
			vim.cmd("grep! " .. vim.fn.shellescape("- \\[ \\]") .. " " .. vim.fn.shellescape(wiki))
			vim.cmd("copen")
		end, { buffer = true, desc = "Wiki: find todos" })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local k = vim.keymap.set
		local buf = ev.buf

		if client and client.name == "omnisharp" then
			local ext = require("omnisharp_extended")
			k("n", "gd", ext.lsp_definitions, { buffer = buf, desc = "Go to Definition" })
			k("n", "<leader>gd", ext.lsp_definitions, { buffer = buf, desc = "Go to Definition" })
			k("n", "gi", ext.lsp_implementation, { buffer = buf, desc = "Go to Implementation" })
			k("n", "<leader>gi", ext.lsp_implementation, { buffer = buf, desc = "Go to Implementation" })
			k("n", "gr", ext.lsp_references, { buffer = buf, desc = "Go to References" })
			k("n", "<leader>gr", ext.lsp_references, { buffer = buf, desc = "Go to References" })
			k("n", "<leader>rn", function()
				vim.ui.input({ prompt = "Rename: ", default = vim.fn.expand("<cword>") }, function(new_name)
					if new_name and new_name ~= "" then
						vim.lsp.buf.rename(new_name)
					end
				end)
			end, { buffer = buf, desc = "Smart Rename" })
		else
			k("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to Definition" })
			k("n", "<leader>gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to Definition" })
			k("n", "gi", vim.lsp.buf.implementation, { buffer = buf, desc = "Go to Implementation" })
			k("n", "<leader>gi", vim.lsp.buf.implementation, { buffer = buf, desc = "Go to Implementation" })
			k("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "Go to References" })
			k("n", "<leader>gr", vim.lsp.buf.references, { buffer = buf, desc = "Go to References" })
			k("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Smart Rename" })
		end

		k("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover Documentation" })
		k("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })

		-- vtsls-only: rename the current file and update all importers via LSP
		-- workspace/willRenameFiles (vtsls doesn't expose a _typescript.applyRenameFile command)
		if client and client.name == "vtsls" then
			k("n", "<leader>rf", function()
				local old = vim.api.nvim_buf_get_name(buf)
				vim.ui.input({ prompt = "Rename file: ", default = old, completion = "file" }, function(new)
					if not new or new == "" or new == old then
						return
					end
					local params = {
						files = { { oldUri = vim.uri_from_fname(old), newUri = vim.uri_from_fname(new) } },
					}
					client:request("workspace/willRenameFiles", params, function(_, result)
						if result then
							vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)
						end
						vim.fn.mkdir(vim.fs.dirname(new), "p")
						local ok, err = os.rename(old, new)
						if not ok then
							vim.notify("rename failed: " .. tostring(err), vim.log.levels.ERROR)
							return
						end
						vim.cmd.edit(new)
						pcall(vim.api.nvim_buf_delete, buf, { force = true })
					end, buf)
				end)
			end, { buffer = buf, desc = "Rename file (update imports)" })

			k("n", "<leader>co", function()
				client:exec_cmd({
					command = "typescript.organizeImports",
					arguments = { vim.uri_from_bufnr(buf) },
				})
			end, { buffer = buf, desc = "Organize imports" })

			k("n", "<leader>cs", function()
				client:exec_cmd({
					command = "typescript.sortImports",
					arguments = { vim.uri_from_bufnr(buf) },
				})
			end, { buffer = buf, desc = "Sort imports" })

			k("n", "<leader>cu", function()
				client:exec_cmd({
					command = "typescript.removeUnusedImports",
					arguments = { vim.uri_from_bufnr(buf) },
				})
			end, { buffer = buf, desc = "Remove unused imports" })
		end
		k("n", "<leader>F", function()
			vim.lsp.buf.format({ async = true })
		end, { buffer = buf, desc = "Format File" })
		k("n", "]d", function()
			vim.diagnostic.goto_next({ float = true })
		end, { buffer = buf, desc = "Next diagnostic" })
		k("n", "[d", function()
			vim.diagnostic.goto_prev({ float = true })
		end, { buffer = buf, desc = "Prev diagnostic" })
	end,
})

--------------------------------------------------------------------------------
-- AI code review (<leader>ar on visual selection, no plugins needed)
--------------------------------------------------------------------------------

vim.keymap.set("v", "<leader>ar", function()
	local lines = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"), { type = vim.fn.visualmode() })
	local code = table.concat(lines, "\n")
	local key = vim.env.GEMINI_API_KEY
	if not key or key == "" then
		vim.notify("GEMINI_API_KEY not set", vim.log.levels.ERROR)
		return
	end

	local body = vim.json.encode({
		contents = {
			{
				parts = {
					{
						text = "Review this code for syntax errors and logic bugs. Be concise.\n\n```\n"
							.. code
							.. "\n```",
					},
				},
			},
		},
	})

	vim.notify("Reviewing with Gemini...", vim.log.levels.INFO)

	vim.system({
		"curl",
		"-s",
		"-X",
		"POST",
		"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" .. key,
		"-H",
		"Content-Type: application/json",
		"-d",
		body,
	}, { text = true }, function(result)
		local ok, data = pcall(vim.json.decode, result.stdout)
		local text
		if ok and data.candidates and data.candidates[1] then
			text = data.candidates[1].content.parts[1].text
		else
			text = "Error: " .. (result.stdout or result.stderr or "unknown")
		end

		vim.schedule(function()
			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n"))
			vim.bo[buf].filetype = "markdown"
			local width = math.floor(vim.o.columns * 0.6)
			local height = math.floor(vim.o.lines * 0.5)
			vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				style = "minimal",
				border = "rounded",
				width = width,
				height = height,
				row = math.floor((vim.o.lines - height) / 2),
				col = math.floor((vim.o.columns - width) / 2),
			})
			vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
		end)
	end)
end, { desc = "AI: review selection" })
