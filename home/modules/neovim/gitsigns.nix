{...}: {
  programs.nvf.settings.vim.lazy.plugins.gitsigns-nvim = {
    package = "gitsigns-nvim";
    event = ["BufReadPre"];
    setupModule = "gitsigns";
    setupOpts = {
      signs = {
        add = {text = "│";};
        change = {text = "│";};
        delete = {text = "󰍵";};
        topdelete = {text = "‾";};
        changedelete = {text = "󱗜";};
        untracked = {text = "│";};
      };
      signcolumn = true;
      linehl = false;
    };
  };

  programs.nvf.settings.vim.keymaps = [
    {
      key = "<leader>gsh";
      action = ":Gitsigns stage_hunk<CR>";
      mode = ["n"];
      desc = "Stage hunk";
    }
    {
      key = "<leader>grh";
      action = ":Gitsigns reset_hunk<CR>";
      mode = ["n"];
      desc = "Reset hunk";
    }

    {
      key = "<leader>gv";
      action = ":Gitsigns preview_hunk_inline<CR>";
      mode = ["n"];
      desc = "Reset hunk";
    }
    {
      key = "<leader>gsb";
      action = ":Gitsigns stage_buffer<CR>";
      mode = ["n"];
      desc = "Stage buffer";
    }
    {
      key = "<leader>grb";
      action = ":Gitsigns reset_buffer<CR>";
      mode = ["n"];
      desc = "Reset buffer";
    }
    {
      key = "<leader>gb";
      action = ":Gitsigns blame_line<CR>";
      mode = ["n"];
      desc = "Blame line";
    }
    {
      key = "<leader>gd";
      action = ":Gitsigns diffthis<CR>";
      mode = ["n"];
      desc = "Diff this";
    }
    {
      key = "<leader>gtd";
      action = ":Gitsigns toggle_deleted<CR>";
      mode = ["n"];
      desc = "Toggle deleted";
    }
    {
      key = "<leader>gtb";
      action = ":Gitsigns toggle_current_line_blame<CR>";
      mode = ["n"];
      desc = "Toggle line blame";
    }
    {
      key = "<leader>gtl";
      action = ":Gitsigns toggle_linehl<CR>";
      mode = ["n"];
      desc = "Toggle line highlight";
    }
    {
      key = "]g";
      action = ":Gitsigns next_hunk<CR>";
      mode = ["n"];
      desc = "Next hunk";
    }
    {
      key = "[g";
      action = ":Gitsigns prev_hunk<CR>";
      mode = ["n"];
      desc = "Previous hunk";
    }
  ];
}
