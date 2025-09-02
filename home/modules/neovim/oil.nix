{
  pkgs,
  ...
}: {
  programs.nvf = {
            settings = {
      # Use the non-lazy plugin API
      vim.extraPlugins = {
        oil = {
          package = pkgs.vimPlugins.oil-nvim;
          setup =
            /*
            lua
            */
            ''

              require('oil').setup {
                delete_to_trash = false,
                skip_confirm_for_simple_edits = true,
                show_hidden = true,
                lsp_file_methods = {
                  timeout_ms = 2500,
                  autosave_changes = true,
                },
                preview = { max_width = 0.4 },
                float = {
                  max_width = 40,
                  max_height = 40,
                  border = 'rounded',
                  win_options = { winblend = 30 },
                  override = function(conf)
                    conf.row = 3
                    conf.col = 8
                    return conf
                  end,
                },
                keymaps = {
                  ['<C-c>'] = 'actions.close',
                  ['q'] = 'actions.close',
                  ['<BS>'] = 'actions.parent',
                  ['|'] = 'actions.select_vsplit',
                  ['s'] = 'actions.select_vsplit',
                  ['\\'] = 'actions.select_split',
                },
              }

              vim.keymap.set('n', '<leader>e', require('oil').toggle_float)
            '';
        };

        # dependencies
        devicons = {
          package = pkgs.vimPlugins.nvim-web-devicons;
        };
        windowpicker = {
          package = pkgs.vimPlugins.nvim-window-picker;
        };
      };
    };
  };
}
