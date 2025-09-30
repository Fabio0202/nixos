{pkgs, ...}: {
  programs.nvf.settings = {
    vim.startPlugins = with pkgs.vimPlugins; [
      vimtex
    ];

    vim.luaConfigPost = ''
              -- Viewer / compiler
              vim.g.vimtex_view_method = "zathura"
              vim.g.vimtex_compiler_method = "latexmk"

              -- Force latexmk settings
              vim.g.vimtex_compiler_latexmk = {
                executable = "latexmk",
                options = {
                  "-pdf",
                  "-interaction=nonstopmode",
                  "-synctex=1",
                },
              }

              -- Async compile with neovim-remote (requires pkgs.neovim-remote)
              vim.g.vimtex_compiler_progname = "nvr"
              -- Performance tweaks
              vim.g.vimtex_syntax_conceal_disable = 1
              vim.g.vimtex_fold_enabled = 0
              vim.g.vimtex_complete_enabled = 0
              vim.g.vimtex_indent_enabled = 0
              vim.g.vimtex_matchparen_enabled = 0
          require("nvim-treesitter.configs").setup {
            highlight = { disable = { "latex" } },
          }
      vim.g.markview_filetypes = { "markdown" }
    '';

    vim.keymaps = [
      {
        mode = "n";
        key = "<leader>mm";
        action = "<cmd>VimtexCompile<cr>";
        desc = "LaTeX: Start/Stop continuous compilation";
      }
      {
        mode = "n";
        key = "<leader>mv";
        action = "<cmd>VimtexView<cr>";
        desc = "LaTeX: Open PDF viewer";
      }
      {
        mode = "n";
        key = "<leader>mc";
        action = "<cmd>VimtexClean<cr>";
        desc = "LaTeX: Clean aux files";
      }
    ];
  };

  home.packages = with pkgs; [
    (texlive.combine {
      inherit (texlive) scheme-medium moderncv latexmk;
    })
    zathura
    neovim-remote
  ];
}
