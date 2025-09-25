{...}: {
  programs.nvf.settings = {
    vim.notes.obsidian = {
      enable = false;
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
        modes = ["n"];
        description = "Open today's note in Obsidian";
      }
      {
        key = "<leader>on";
        action = ":ObsidianNew<CR>";
        modes = ["n"];
        description = "Create a new note in Obsidian";
      }
      {
        key = "<leader>of";
        action = ":ObsidianSearch<CR>";
        modes = ["n"];
        description = "Search notes in Obsidian";
      }
      {
        key = "<leader>ol";
        action = ":ObsidianLink<CR>";
        modes = ["n"];
        description = "Insert link to another note in Obsidian";
      }
      {
        key = "<leader>ob";
        action = ":ObsidianBacklinks<CR>";
        modes = ["n"];
        description = "Show backlinks for current note in Obsidian";
      }
      {
        key = "<leader>nc";
        action = ":ObsidianCalendar<CR>";
        modes = ["n"];
        description = "Open calendar view in Obsidian";
      }
      {
        key = "<leader>ot";
        action = ":ObsidianTag<CR>";
        modes = ["n"];
        description = "Search notes by tag in Obsidian";
      }
    ];
  };
}
