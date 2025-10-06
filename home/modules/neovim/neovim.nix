{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./options.nix
    # we don't need latex on the servers
    # ./latex.nix
    ./languages.nix
    ./gitsigns.nix
    ./bufferline.nix
    ./oil.nix
  ];

  programs.nvf = {
    enable = true;
    settings = {
      vim.navigation.harpoon = {
        enable = true;
        mappings = {
          file1 = "<leader>1";
          file2 = "<leader>2";
          file3 = "<leader>3";
          file4 = "<leader>4";
        };
      };
      vim.utility.yanky-nvim.enable = true;
      vim.visuals.highlight-undo.enable = true;
      vim.languages.markdown.extensions.markview-nvim.enable = true;
      vim.utility.yanky-nvim.setupOpts.ring.storage = "memory";
      vim.utility.undotree.enable = true;
      vim.utility.yazi-nvim.enable = true;

      vim.filetree.neo-tree = {
        enable = true;
        setupOpts = {
          auto_clean_after_session_restore = true;
          close_if_last_window = true;
          default_source = "git_status";

          sources = ["git_status"];

          source_selector = {
            winbar = true;
            content_layout = "center";
            sources = [
              {
                source = "git_status";
                display_name = " Git";
              }
            ];
          };

          default_component_configs = {
            indent = {
              padding = 0;
              indent_size = 1;
            };
            icon = {
              folder_closed = "";
              folder_open = "";
              folder_empty = "";
              default = "";
            };
            modified = {symbol = "●";};
            git_status = {
              symbols = {
                added = "";
                deleted = "";
                modified = "";
                renamed = "➜";
                untracked = "★";
                ignored = "◌";
                unstaged = "✗";
                staged = "✓";
                conflict = "";
              };
            };
          };

          window = {
            position = "right";
            width = 30;
            mappings = {
              "<space>" = null;
              "[b" = "prev_source";
              "]b" = "next_source";
              "o" = "open";
              "O" = "system_open";
              "h" = "parent_or_close";
              "l" = "child_or_open";
              "Y" = "copy_selector";
            };
          };

          filesystem = {
            follow_current_file = {enabled = true;};
            hijack_netrw_behavior = "open_current";
            use_libuv_file_watcher = true;
          };

          event_handlers = [
            {
              event = "neo_tree_buffer_enter";
              handler = lib.generators.mkLuaInline ''
                function(_)
                  vim.opt_local.signcolumn = "auto"
                end
              '';
            }
          ];
        };
      };
      vim.utility.motion.leap.mappings.leapForwardTo = "s";
      vim.utility.motion.leap.mappings.leapBackwardTo = "S";
      vim.dashboard.alpha.enable = false;
      vim.dashboard.startify.enable = true;
      vim.dashboard.startify.sessionSort = true;
      vim.dashboard.startify.sessionPersistence = true;
      vim.dashboard.startify.changeToVCRoot = true;
      vim.vimAlias = true;

      vim = {
        assistant = {
          copilot.enable = true;

          copilot.setupOpts.suggestion.auto_trigger = true;
          copilot.mappings = {
            suggestion.accept = "<C-s>";
            suggestion.acceptWord = "<C-d>";
          };
          copilot.setupOpts.suggestion.enabled = true;
        };

        visuals = {
          rainbow-delimiters.enable = true;
        };

        terminal.toggleterm = {
          enable = true;
          lazygit.enable = true;
        };

        utility = {
          smart-splits.enable = true;
          motion.leap.enable = true;
        };

        binds.whichKey.enable = true;

        autopairs.nvim-autopairs.enable = true;

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = true;
        };

        autocomplete = {
          blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;

            setupOpts.sources.default = [
              "lsp"
              "path"
              "snippets"
            ];
            sourcePlugins.buffer.enable = false;
          };
        };

        # now add the lazy plugins
        lazy.plugins = {
          telescope = {
            package = "telescope";
            cmd = ["Telescope"];
            keys = [
              {
                mode = "n";
                key = "<leader>ff";
                action = "<cmd>Telescope find_files<cr>";
                desc = "Find files";
              }
              {
                mode = "n";
                key = "<leader>fw";
                action = "<cmd>Telescope live_grep<cr>";
                desc = "Live grep";
              }
              {
                mode = "n";
                key = "<leader>fo";
                action = "<cmd>Telescope oldfiles<cr>";
                desc = "Old files";
              }
            ];
          };

          nvim-treesitter = {
            package = "nvim-treesitter";
            event = ["BufReadPost" "BufNewFile"];
          };

          toggleterm-nvim = {
            package = "toggleterm-nvim";
            cmd = ["ToggleTerm"];
            keys = [
              {
                mode = "n";
                key = "<leader>tg";
                action = "<cmd>ToggleTerm<cr>";
                desc = "Toggle terminal";
              }
            ];
          };
        };

        # custom keymaps (non-plugin specific or always-on)

        keymaps = [
          {
            mode = "n";
            key = "<leader>lf";
            action = ":Yazi<cr>";
            desc = "file explorer (yazi)";
          }
          {
            mode = "n";
            key = "<leader>r";
            action = ":Neotree toggle<CR>";
            desc = "NeoT[r]ee Toggle";
          }
          {
            mode = "n";
            key = "<C-h>";
            action = "<cmd>lua require('smart-splits').move_cursor_left()<cr>";
            desc = "Move to left split";
          }

          {
            mode = "n";
            key = "<leader>u";
            action = ":UndotreeToggle<CR>";
            desc = "Undo Tree";
          }
          {
            mode = "n";
            key = "<C-j>";
            action = "<cmd>lua require('smart-splits').move_cursor_down()<cr>";
            desc = "Move to below split";
          }
          {
            mode = "n";
            key = "<C-k>";
            action = "<cmd>lua require('smart-splits').move_cursor_up()<cr>";
            desc = "Move to above split";
          }
          {
            mode = "n";
            key = "<C-l>";
            action = "<cmd>lua require('smart-splits').move_cursor_right()<cr>";
            desc = "Move to right split";
          }
          {
            mode = "n";
            key = "<C-Up>";
            action = "<cmd>lua require('smart-splits').resize_up()<cr>";
            desc = "Resize split up";
          }
          {
            mode = "n";
            key = "<C-Down>";
            action = "<cmd>lua require('smart-splits').resize_down()<cr>";
            desc = "Resize split down";
          }
          {
            mode = "n";
            key = "<C-Left>";
            action = "<cmd>lua require('smart-splits').resize_left()<cr>";
            desc = "Resize split left";
          }
          {
            mode = "n";
            key = "<C-Right>";
            action = "<cmd>lua require('smart-splits').resize_right()<cr>";
            desc = "Resize split right";
          }
          {
            mode = "n";
            key = "|";
            action = "<cmd>vsplit<cr>";
            desc = "Vertical Split";
          }
          {
            mode = "n";
            key = "\\";
            action = "<cmd>split<cr>";
            desc = "Horizontal Split";
          }
          {
            mode = "n";
            key = "<A-j>";
            action = "<cmd>m .+1<cr>==";
            desc = "Move line down";
          }
          {
            mode = "n";
            key = "<A-k>";
            action = "<cmd>m .-2<cr>==";
            desc = "Move line up";
          }
          {
            mode = "i";
            key = "<A-j>";
            action = "<esc><cmd>m .+1<cr>==gi";
            desc = "Move line down (insert)";
          }
          {
            mode = "i";
            key = "<A-k>";
            action = "<esc><cmd>m .-2<cr>==gi";
            desc = "Move line up (insert)";
          }
          {
            mode = "v";
            key = "<A-j>";
            action = ":m '>+1<cr>gv=gv";
            desc = "Move selection down";
          }
          {
            mode = "v";
            key = "<A-k>";
            action = ":m '<-2<cr>gv=gv";
            desc = "Move selection up";
          }
          {
            mode = "n";
            key = "<leader>q";
            action = "<cmd>update<cr><cmd>q<cr>";
            desc = "Save and Quit";
          }
        ];
      };
    };
  };
}
