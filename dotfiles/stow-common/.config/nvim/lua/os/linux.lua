-- Linux/Nix LSP setup. Loaded from init.lua when not on Windows.
-- Binaries are provided by the flake's runtimeInputs — no Mason needed.
-- cmd + filetypes are specified explicitly since $VIMRUNTIME/lsp/ may be absent.

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
		nixd = {
			cmd = { "nixd" },
			filetypes = { "nix" },
			root_markers = { "flake.nix", ".git" },
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
		gopls = {
			cmd = { "gopls" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_markers = { "go.work", "go.mod", ".git" },
		},
		rust_analyzer = {
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
			root_markers = { "Cargo.toml", ".git" },
		},
		-- C# / .NET — OmniSharpRoslyn (omnisharp-roslyn from nixpkgs, on PATH via nvim-shell runtimeInputs).
		-- offset_encoding = "utf-16": OmniSharp reports UTF-16 columns (matches VS Code / windows.lua).
		omnisharp = {
			cmd = { "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
			filetypes = { "cs", "vb" },
			offset_encoding = "utf-16",
			root_markers = { "global.json", ".git" },
			root_dir = function(bufnr, on_dir)
				local fname = vim.api.nvim_buf_get_name(bufnr)
				if fname == "" then
					return
				end
				local root = vim.fs.root(fname, function(name)
					return name:match("%.sln$") or name:match("%.csproj$") or name == "global.json" or name == ".git"
				end)
				on_dir(root)
			end,
			settings = {
				omnisharp = {
					enable_roslyn_analyzers = true,
					enable_import_completion = true,
					sdk_include_prereleases = true,
					analyze_open_documents_only = false,
				},
			},
		},
	}

	for name, config in pairs(servers) do
		vim.lsp.config(name, config)
		vim.lsp.enable(name)
	end
end

return M
