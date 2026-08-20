return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#130f1a',
				base01 = '#130f1a',
				base02 = '#9a918e',
				base03 = '#9a918e',
				base04 = '#f8ede9',
				base05 = '#fffaf8',
				base06 = '#fffaf8',
				base07 = '#fffaf8',
				base08 = '#ffa29f',
				base09 = '#ffa29f',
				base0A = '#ffbeab',
				base0B = '#b7ffa5',
				base0C = '#ffddd2',
				base0D = '#ffbeab',
				base0E = '#ffcaba',
				base0F = '#ffcaba',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#9a918e',
				fg = '#fffaf8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ffbeab',
				fg = '#130f1a',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#9a918e' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffddd2', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ffcaba',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ffbeab',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ffbeab',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ffddd2',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#b7ffa5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#f8ede9' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#f8ede9' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#9a918e',
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
