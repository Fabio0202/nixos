return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#121318',
				base01 = '#121318',
				base02 = '#999ca5',
				base03 = '#999ca5',
				base04 = '#eff3ff',
				base05 = '#f8faff',
				base06 = '#f8faff',
				base07 = '#f8faff',
				base08 = '#ff9fb9',
				base09 = '#ff9fb9',
				base0A = '#bccdff',
				base0B = '#a5ffb3',
				base0C = '#dbe4ff',
				base0D = '#bccdff',
				base0E = '#c8d6ff',
				base0F = '#c8d6ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#999ca5',
				fg = '#f8faff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#bccdff',
				fg = '#121318',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#999ca5' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#dbe4ff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#c8d6ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#bccdff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#bccdff',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#dbe4ff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffb3',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#eff3ff' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#eff3ff' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#999ca5',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
