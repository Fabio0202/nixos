{ ... }: {
  programs.nvf = {
    settings = {

      # 🔑 Extra keymaps for unsupported bufferline actions
      vim.keymaps = [
        { mode = "n"; key = "<leader>bl"; action = "<cmd>BufferLineCloseRight<cr>"; desc = "Close buffers to right"; }
        { mode = "n"; key = "<leader>bh"; action = "<cmd>BufferLineCloseLeft<cr>"; desc = "Close buffers to left"; }
        { mode = "n"; key = "<leader>ba"; action = "<cmd>BufferLineCloseOthers<cr>"; desc = "Close other buffers"; }
        { mode = "n"; key = "<leader>bc"; action = "<cmd>BufferLinePickClose<cr>"; desc = "Pick buffer to close"; }
        { mode = "n"; key = "<leader>bt"; action = "<cmd>BufferLineTogglePin<cr>"; desc = "Toggle pin buffer"; }
      ];
      vim.tabline.nvimBufferline = {
        enable = true;

        mappings = {
          closeCurrent   = "<leader>x";  # Close current buffer
          cycleNext      = "<S-l>";       # Next buffer
          cyclePrevious  = "<S-h>";       # Previous buffer
          moveNext       = "<leader>bmh"; # Move buffer right
          movePrevious   = "<leader>bml"; # Move buffer left
          pick           = "<leader>bp";  # Pick buffer interactively
          # TODO: implement pick close
          # pickClose      = "<leader>bd";  # Pick buffer to delete
          # TODO: custom mappings for close left and right?
          # closeRight     = "<leader>bh";  # Delete all buffers to the right
          # closeLeft      = "<leader>bl";  # Delete all buffers to the left

          # TODO: custom mappings for sort by modified
          # sortByModified = "<leader>bsm";  # Sort by last modified (leftmost)
          sortByDirectory = "<leader>bsd";  # Sort by last modified (leftmost)
        };

        setupOpts = {
          options = {
            numbers = "none";
            modified_icon = "●";
            buffer_close_icon = "";
            close_icon = "";
            left_trunc_marker = "";
            right_trunc_marker = "";

            sort_by = "id";
            show_buffer_icons = true;
            show_buffer_close_icons = true;
            show_close_icon = true;
            show_tab_indicators = true;
            always_show_bufferline = true;

            diagnostics = "nvim_lsp";

            diagnostics_indicator = {
              _type = "lua-inline";
              expr = ''
                function(count, level, diagnostics_dict, context)
                  local icon = (level == "error" and " ")
                    or (level == "warning" and " ")
                    or " "
                  return icon 
                  end
              '';
            };

            offsets = [
              {
                filetype = "NvimTree";
                text = "File Explorer";
                highlight = "Directory";
                separator = true;
              }
            ];

            close_command = "bdelete! %d";
            right_mouse_command = "bdelete! %d";
            left_mouse_command = "buffer %d";

            persist_buffer_sort = true;

            tab_size = 14;
            max_name_length = 18;
            max_prefix_length = 15;
          };
        };
      };
    };
  };
}
