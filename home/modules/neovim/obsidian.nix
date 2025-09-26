{...}: {
  programs.nvf.settings = {
    vim.notes.obsidian = {
      enable = true;
      setupOpts = {
        workspaces = [
          {
            name = "personal";
            path = "~/projects/pages/";
          }
        ];
      };
    };
    vim.keymaps = [
      {
        key = "<leader>od";
        action = ":ObsidianToday<CR>";
        mode = ["n"];
        desc = "Open today's note in Obsidian";
      }
      {
        key = "<leader>on";
        action = ":ObsidianNew<CR>";
        mode = ["n"];
        desc = "Create a new note in Obsidian";
      }
      {
        key = "<leader>of";
        action = ":ObsidianSearch<CR>";
        mode = ["n"];
        desc = "Search notes in Obsidian";
      }
      {
        key = "<leader>ol";
        action = ":ObsidianLink<CR>";
        mode = ["n"];
        desc = "Insert link to another note in Obsidian";
      }
      {
        key = "<leader>ob";
        action = ":ObsidianBacklinks<CR>";
        mode = ["n"];
        desc = "Show backlinks for current note in Obsidian";
      }
      {
        key = "<leader>nc";
        action = ":ObsidianCalendar<CR>";
        mode = ["n"];
        desc = "Open calendar view in Obsidian";
      }
      {
        key = "<leader>ot";
        action = ":ObsidianTag<CR>";
        mode = ["n"];
        desc = "Search notes by tag in Obsidian";
      }
    ];
  };
}
