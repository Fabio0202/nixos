{...}: {
  programs.nvf.settings.vim.gitsigns-nvim = {
    package = "gitsigns-nvim";
    event = ["BufReadPre"];
    setupModule = "gitsigns";
    setupOptsModule = {
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

  keymaps = [
    {
      key = "<leader>gsh";
      action = ":Gitsigns stage_hunk<CR>";
      modes = ["n"];
      description = "Stage hunk";
    }
    {
      key = "<leader>grh";
      action = ":Gitsigns reset_hunk<CR>";
      modes = ["n"];
      description = "Reset hunk";
    }
    {
      key = "<leader>gsb";
      action = ":Gitsigns stage_buffer<CR>";
      modes = ["n"];
      description = "Stage buffer";
    }
    {
      key = "<leader>grb";
      action = ":Gitsigns reset_buffer<CR>";
      modes = ["n"];
      description = "Reset buffer";
    }
    {
      key = "<leader>gb";
      action = ":Gitsigns blame_line<CR>";
      modes = ["n"];
      description = "Blame line";
    }
    {
      key = "<leader>gd";
      action = ":Gitsigns diffthis<CR>";
      modes = ["n"];
      description = "Diff this";
    }
    {
      key = "<leader>gtd";
      action = ":Gitsigns toggle_deleted<CR>";
      modes = ["n"];
      description = "Toggle deleted";
    }
    {
      key = "<leader>gtb";
      action = ":Gitsigns toggle_current_line_blame<CR>";
      modes = ["n"];
      description = "Toggle line blame";
    }
    {
      key = "<leader>gtl";
      action = ":Gitsigns toggle_linehl<CR>";
      modes = ["n"];
      description = "Toggle line highlight";
    }
    {
      key = "]g";
      action = ":Gitsigns next_hunk<CR>";
      modes = ["n"];
      description = "Next hunk";
    }
    {
      key = "[g";
      action = ":Gitsigns prev_hunk<CR>";
      modes = ["n"];
      description = "Previous hunk";
    }
  ];
}
