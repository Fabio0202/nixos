{...}: {
  programs.nvf = {
    settings = {
      # this covers your "vim.g.*"
      vim.globals = {
        vimtex_main_file = "main.tex";
        ui_notifications_enabled = true;
        diagnostics_mode = 2;
        icons_enabled = true;
        codelens_enabled = true;
        autoformat_enabled = true;
        highlighturl_enabled = true;
        lsp_handlers_enabled = true;
        conceallevel = 2;
        cmp_enabled = true;
        autopairs_enabled = true;
        # mapleader = " ";
        # maplocalleader = " ";
      };
      # this covers your "vim.opt.*"
      vim.options = {
        autoread = true;
        showtabline = 2;
        report = 1000;
        expandtab = true;
        swapfile = false;
        foldenable = true;
        foldlevel = 99;
        conceallevel = 2;
        foldlevelstart = 99;
        history = 100;
        number = true;
        completeopt = "menuone,noselect";
        relativenumber = true;
        wrap = false;
        ignorecase = true;
        linebreak = true;
        infercase = true;
        laststatus = 3;
        preserveindent = true;
        pumheight = 10;
        scrolloff = 8;
        shiftwidth = 2;
        showmode = true;
        smartcase = true;
        smartindent = true;
        tabstop = 4;
        termguicolors = true;
        timeoutlen = 10;
        updatetime = 400;
        virtualedit = "block";
        signcolumn = "yes";
        sidescrolloff = 7;
        splitright = true;
        splitbelow = true;
        hlsearch = false;
        mouse = "a";
        clipboard = "unnamedplus";
        breakindent = true;
        undofile = true;
        fileencoding = "utf-8";
        copyindent = true;
        writebackup = false;
        iskeyword = "@,48-57,192-255,_,-";

        # fillchars = { eob = " " };   # ⚠️ if nvf complains, move this to vim.extraConfig
      };

      vim.augroups = [
        {
          name = "YankHighlight";
          clear = true; # clear any existing autocmds in this group
        }
      ];
      # autocommand: highlight on yank
      vim.autocmds = [
        {
          event = ["TextYankPost"];
          desc = "Highlight on yank";
          command = "lua vim.highlight.on_yank()";
          group = "YankHighlight";
        }
      ];
    };
  };
}
