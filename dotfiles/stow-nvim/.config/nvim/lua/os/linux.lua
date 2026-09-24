-- Linux LSP setup. Loaded from init.lua when not on Windows.
-- Binaries are system packages on this Omarchy/Arch box (omarchy pkg add
-- lua-language-server pyright typescript-language-server rust-analyzer) —
-- no Mason needed. cmd + filetypes are specified explicitly.

local M = {}

function M.setup_lsps()
	local servers = {
		lua_ls = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
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
		pyright = {
			cmd = { "pyright-langserver", "--stdio" },
			filetypes = { "python" },
			root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
		},
		ts_ls = {
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
		},
		rust_analyzer = {
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
			root_markers = { "Cargo.toml", ".git" },
		},
	}

	for name, config in pairs(servers) do
		vim.lsp.config(name, config)
		vim.lsp.enable(name)
	end
end

return M
