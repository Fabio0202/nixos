{pkgs, ...}: {
  programs.nvf.settings = {
    vim.startPlugins = with pkgs.vimPlugins; [
      vimtex
    ];

    vim.luaConfigPost = ''
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
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
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-medium fontawesome5;
    })
    zathura
  ];
}
