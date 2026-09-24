-- Windows-only nvim setup. Loaded from init.lua when vim.fn.has("win32") == 1.
-- Hardcoded paths (AppData, C:/Program Files, Mason .exe shims) live here so the
-- rest of init.lua stays portable.

local M = {}

-- PATH fixups + Windows-specific options. Runs before plugins load.
function M.setup_env()
	-- npm global bin (tree-sitter CLI lives here)
	local npm_bin = vim.fn.expand("~/AppData/Roaming/npm")
	if vim.uv.fs_stat(npm_bin) and not vim.env.PATH:find(npm_bin, 1, true) then
		vim.env.PATH = npm_bin .. ";" .. vim.env.PATH
	end
	-- tree-sitter.exe directly (vim.system/libuv can't run .cmd wrappers)
	local ts_cli = vim.fn.expand("~/AppData/Roaming/npm/node_modules/tree-sitter-cli")
	if vim.uv.fs_stat(ts_cli .. "/tree-sitter.exe") and not vim.env.PATH:find(ts_cli, 1, true) then
		vim.env.PATH = ts_cli .. ";" .. vim.env.PATH
	end

	-- Reuse ripgrep bundled with VS Code (no separate install needed)
	local vscode_rg = "C:/Program Files/Microsoft VS Code/resources/app/node_modules/@vscode/ripgrep/bin"
	if vim.uv.fs_stat(vscode_rg) and not vim.env.PATH:find(vscode_rg, 1, true) then
		vim.env.PATH = vscode_rg .. ";" .. vim.env.PATH
	end

	-- MinGW gcc (installed via choco) for treesitter parser compilation
	local mingw_bin = "C:/ProgramData/mingw64/mingw64/bin"
	if vim.uv.fs_stat(mingw_bin) and not vim.env.PATH:find(mingw_bin, 1, true) then
		vim.env.PATH = mingw_bin .. ";" .. vim.env.PATH
	end

	vim.opt.fileformats = "dos,unix"
end

-- Prettier override for conform.nvim: invoke node directly on prettier.cjs
-- because libuv can't spawn Mason/npm's .cmd wrappers.
function M.prettier_formatter_spec()
	return {
		command = "node",
		args = {
			vim.fn.expand("~/AppData/Roaming/npm/node_modules/prettier/bin/prettier.cjs"),
			"--stdin-filepath",
			"$FILENAME",
			"--plugin",
			vim.fn.expand("~/AppData/Roaming/npm/node_modules/@shopify/prettier-plugin-liquid/dist/index.js"),
		},
		stdin = true,
	}
end

-- Mason-backed LSP configs. Every cmd here goes through node or an .exe directly
-- to dodge the .cmd-wrapper problem. Must run after lazy.setup() since it relies
-- on blink.cmp capabilities having been wired via vim.lsp.config("*", ...).
function M.setup_lsps()
	local mason_pkg = vim.fn.expand("~/AppData/Local/nvim-data/mason/packages")

	-- vtsls: VSCode's TypeScript service exposed as an LSP. Provides "Move to file",
	-- file-rename → import updates, organize imports, and richer code actions than ts_ls.
	vim.lsp.config("vtsls", {
		cmd = { "node", mason_pkg .. "/vtsls/node_modules/@vtsls/language-server/bin/vtsls.js", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
		settings = {
			typescript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = { completeFunctionCalls = true },
				inlayHints = {
					parameterNames = { enabled = "literals" },
					variableTypes = { enabled = false },
					propertyDeclarationTypes = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
				},
			},
			javascript = {
				updateImportsOnFileMove = { enabled = "always" },
			},
			vtsls = {
				experimental = {
					completion = { enableServerSideFuzzyMatch = true },
				},
			},
		},
	})

	local function vscode_ls_cmd(pkg_name, bin_name)
		-- vscode-langservers-extracted bins live under the package's node_modules
		local candidates = {
			mason_pkg .. "/" .. pkg_name .. "/node_modules/vscode-langservers-extracted/bin/" .. bin_name .. ".js",
			mason_pkg .. "/" .. pkg_name .. "/node_modules/.bin/" .. bin_name,
		}
		for _, p in ipairs(candidates) do
			if vim.uv.fs_stat(p) then
				return { "node", p, "--stdio" }
			end
		end
	end

	vim.lsp.config("cssls", {
		cmd = vscode_ls_cmd("css-lsp", "vscode-css-language-server"),
		filetypes = { "css", "scss", "less" },
		root_markers = { ".git" },
	})
	vim.lsp.config("html", {
		cmd = vscode_ls_cmd("html-lsp", "vscode-html-language-server"),
		filetypes = { "html" },
		root_markers = { ".git" },
	})
	-- 3. C# / .NET Setup
	vim.lsp.config("omnisharp", {
		cmd = {
			vim.fn.expand("~/AppData/Local/nvim-data/mason/packages/omnisharp/libexec/OmniSharp.exe"),
			"--languageserver",
			"--hostPID",
			tostring(vim.fn.getpid()),
		},
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
	})

	-- Shopify Liquid LSP — deferred so the glob doesn't block startup
	vim.schedule(function()
		local _tc_matches = vim.fn.glob(
			vim.fn.expand("~") .. "/.vscode/extensions/shopify.theme-check-vscode-*/dist/node/server.js",
			false,
			true
		)
		local _tc_bin = _tc_matches[1]
		if _tc_bin then
			vim.lsp.config("theme_check", {
				cmd = { "node", _tc_bin },
				filetypes = { "liquid" },
				root_markers = { ".theme-check.yml", ".theme-check.yaml", ".git" },
			})
			vim.lsp.enable("theme_check")
		end
	end)

	-- Emmet language server — installed via: npm install -g @olrtg/emmet-language-server
	vim.schedule(function()
		local emmet_server = vim.fn.expand("~/AppData/Roaming/npm/node_modules/@olrtg/emmet-language-server/dist/index.js")
		if vim.uv.fs_stat(emmet_server) then
			vim.lsp.config("emmet_language_server", {
				cmd = { "node", emmet_server, "--stdio" },
				filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact", "liquid" },
				root_markers = { ".git", "package.json" },
				init_options = {
					includeLanguages = {
						javascriptreact = "html",
						typescriptreact = "html",
						liquid = "html",
					},
				},
			})
			vim.lsp.enable("emmet_language_server")
		end
	end)

	-- Marksman: Markdown LSP — provides [[wiki-link]] completion for vimwiki files
	-- Must use the .exe directly: libuv can't execute Mason's .cmd wrapper on Windows
	vim.lsp.config("marksman", {
		cmd = { vim.fn.expand("~/AppData/Local/nvim-data/mason/packages/marksman/marksman.exe"), "server" },
		-- vimwiki sets ft to "vimwiki" (not "markdown") for files in the wiki path
		filetypes = { "markdown", "vimwiki" },
		root_markers = { ".marksman.toml", ".git" },
	})

	vim.lsp.enable({ "vtsls", "cssls", "html", "omnisharp", "marksman" })
end

-- lazy.nvim plugin specs that only make sense on Windows.
-- Spliced into the lazy.setup() table in init.lua.
function M.lazy_specs()
	return {
		-- nvim-treesitter: on Nix the parsers are baked in via neovimWithParsers.
		-- On Windows, lazy manages the plugin and installs missing parsers via :TSUpdate.
		{
			"nvim-treesitter/nvim-treesitter",
			event = { "BufReadPost", "BufNewFile" },
			build = ":TSUpdate",
			config = function()
				local wanted = { "javascript", "typescript", "tsx", "css", "html", "liquid", "c_sharp", "csharp" }
				local installed = require("nvim-treesitter.config").get_installed("parsers")
				local missing = vim.tbl_filter(function(lang)
					return not vim.list_contains(installed, lang)
				end, wanted)
				if #missing > 0 then
					vim.schedule(function()
						require("nvim-treesitter").install(missing)
					end)
				end
			end,
		},
		-- Mason: installs LSP binaries on Windows. Not needed on Nix (flake provides them).
		{
			"williamboman/mason.nvim",
			cmd = "Mason",
			config = function()
				require("mason").setup()
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			cmd = "Mason",
			dependencies = { "williamboman/mason.nvim" },
			config = function()
				require("mason-lspconfig").setup()
			end,
		},
	}
end

return M
