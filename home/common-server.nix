{pkgs, ...}: {
  home.packages = with pkgs; [
    syncthing # Sync files across devices automatically
    gh # GitHub CLI tool for repo management
    dysk # Show disk usage (like df but nicer)
    distrobox # Run other Linux distros inside containers
    # wine # Run Windows programs on Linux
    ncdu # Visualize disk usage per folder
    btop # Resource monitor (CPU, memory, disk, network)
    direnv # Manage environment variables per project directory
    unzip # Extract .zip archives
    xdg-utils # Open files/URLs with default desktop apps
    fastfetch # Show system info in terminal (modern neofetch replacement)
    ffmpeg # Convert, edit, and process video/audio
    git # Version control
    lazygit # TUI for Git
  ];

  # Neovim — config lives in ~/.config/nvim/init.lua (stowed).
  # home-manager wraps neovim-unwrapped with treesitter parsers in rtp
  # and puts LSPs / debuggers / formatters on PATH via extraPackages.
  # Replaces the old nvim-shell flake wrapper.
  programs.neovim = {
    enable = true;
    defaultEditor = true; # sets EDITOR / VISUAL to nvim
    vimAlias = true;
    viAlias = true;
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
        bash c cpp css c_sharp go html javascript json lua
        markdown nix python rust toml typescript yaml
      ]))
    ];
    extraPackages = with pkgs; [
      # LSPs
      lua-language-server
      nixd
      pyright
      typescript-language-server
      gopls
      rust-analyzer
      omnisharp-roslyn
      # Debuggers
      netcoredbg
      # Formatters
      stylua
      prettier
      black
      rustfmt
    ];
  };

  # Fonts (needed by GUI + CLI tools rendering text/icons)
  fonts.fontconfig.enable = true;
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };
  imports = [
    ./modules/sh.nix
    # add more generic modules here
  ];
}
