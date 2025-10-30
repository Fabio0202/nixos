{...}: {
  programs.nvf.settings.vim.lazy.plugins = {
    hunk-nvim = {
      package = "hunk-nvim";
      cmd = ["DiffEditor"];
      setupModule = "hunk";
      setupOpts = {
        keys = {
          global = {
            quit = ["q"];
            accept = ["<leader><Cr>"];
            focus_tree = ["<leader>e"];
          };
          tree = {
            expand_node = ["l" "<Right>"];
            collapse_node = ["h" "<Left>"];
            open_file = ["<Cr>"];
            toggle_file = ["a"];
          };
          diff = {
            toggle_hunk = ["A"];
            toggle_line = ["a"];
            toggle_line_pair = ["s"];
            prev_hunk = ["[h"];
            next_hunk = ["]h"];
            toggle_focus = ["<Tab>"];
          };
        };
        ui = {
          tree = {
            mode = "nested";
            width = 35;
          };
          layout = "vertical";
        };
        icons = {
          selected = "󰡖";
          deselected = "";
          partially_selected = "󰛲";
          folder_open = "";
          folder_closed = "";
        };
      };
    };

    diffview-nvim = {
      package = "diffview-nvim";
      cmd = ["DiffviewOpen" "DiffviewClose" "DiffviewToggleFiles" "DiffviewFocusFiles"];
      setupModule = "diffview";
      setupOpts = {
        enhanced_diff_hl = true;
        keymaps = {
          view = {
            "<leader>dv" = "<cmd>DiffviewOpen<cr>";
            "<leader>gD" = "<cmd>DiffviewClose<cr>";
            "<leader>gf" = "<cmd>DiffviewToggleFiles<cr>";
          };
          file_panel = {
            "<leader>dv" = "<cmd>DiffviewClose<cr>";
          };
        };
      };
    };
  };

  programs.nvf.settings.vim.keymaps = [
    {
      key = "<leader>dv";
      action = "<cmd>DiffviewOpen<cr>";
      mode = ["n"];
      desc = "Open diffview";
    }
    {
      key = "<leader>gD";
      action = "<cmd>DiffviewClose<cr>";
      mode = ["n"];
      desc = "Close diffview";
    }
    {
      key = "<leader>gf";
      action = "<cmd>DiffviewToggleFiles<cr>";
      mode = ["n"];
      desc = "Toggle diffview file panel";
    }
    {
      key = "<leader>de";
      action = "<cmd>DiffEditor<cr>";
      mode = ["n"];
      desc = "Open DiffEditor (hunk.nvim)";
    }
  ];
}