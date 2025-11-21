{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    prettierd
    eslint
    stylua
    black
    alejandra
  ];
  programs.nvf = {
    settings = {
      vim.formatter.conform-nvim = {
        enable = true;
        setupOpts.formatters_by_ft = {
          # JS / TS
          javascript = ["prettierd"];
          typescript = ["prettierd"];
          javascriptreact = ["prettierd"];
          typescriptreact = ["prettierd"];

          # Lua
          lua = ["stylua"];

          # Markdown
          markdown = ["prettierd"];

          # Python
          python = ["black"];

          # Nix
          nix = ["alejandra"];
        };
      };

      vim.diagnostics = {
        enable = true;
        config = {
          nvim-lint = {
            enable = true;
            linters_by_ft = {
              javascript = ["eslint"];
              typescript = ["eslint"];
              javascriptreact = ["eslint"];
              typescriptreact = ["eslint"];
            };
          };
          signs = lib.generators.mkLuaInline ''
            {
              text = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN]  = " ",
                [vim.diagnostic.severity.HINT]  = "",
                [vim.diagnostic.severity.INFO]  = "",
              },
            }
          '';
        };
      };
      vim.lsp = {
        formatOnSave = true;
        lspkind.enable = true;
        trouble.enable = true;
        trouble.mappings = {
          documentDiagnostics = "<leader>dd";
          lspReferences = "gr";
          workspaceDiagnostics = "<leader>tw";
        };
        enable = true;
        mappings = {
          format = null;
          goToDefinition = "gd";
        };
      };
      vim.treesitter.enable = true;
      vim.treesitter.autotagHtml = true;
      vim.treesitter.textobjects.enable = true;
      vim.statusline.lualine.enable = true;
      vim.lazy.plugins."better-escape.nvim" = {
        package = pkgs.vimPlugins.better-escape-nvim;
        event = ["BufEnter"];
        setupModule = "better_escape";
        setupOpts = {
          timeout = lib.generators.mkLuaInline "vim.o.timeoutlen";
          default_mappings = false;
          mappings = {
            i.j.j = "<Esc>";
            c.j.j = "<Esc>";
          };
          disable_filetype = ["TelescopePrompt" "toggleterm" "lazygit"];
        };
      };
      vim.languages = {
        html = {
          enable = true;
          lsp = {
            enable = true;
            servers = ["emmet-ls"];
          };
        };
        tailwind = {
          enable = true;
          lsp.enable = true;
        };
        markdown = {
          enable = true;
          treesitter.enable = true;
        };
        css = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };

        yaml = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };
        python = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };
        ts = {
          enable = true;
          treesitter.enable = true;
          lsp.enable = true;
        };
        nix.enable = true;
        #enableLSP.enable = true;
      };
    };
  };
}
