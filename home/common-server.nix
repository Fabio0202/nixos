{ pkgs, ... }: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = with pkgs; [
    syncthing # Sync files across devices automatically
    gh # GitHub CLI tool for repo management
    dysk # Show disk usage (like df but nicer)
    distrobox # Run other Linux distros inside containers
    wine # Run Windows programs on Linux
    ncdu # Visualize disk usage per folder
    btop # Resource monitor (CPU, memory, disk, network)
    direnv # Manage environment variables per project directory
    unzip # Extract .zip archives
    xdg-utils # Open files/URLs with default desktop apps
    neofetch # Show system info in terminal
    ffmpeg # Convert, edit, and process video/audio
    git # Version control
    # TODO: do I still need this though?
    neovim # Terminal text editor
    lazygit # TUI for Git
    sqlite # Lightweight database engine
  ];

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
    ./modules/neovim/neovim.nix
    ./modules/sh.nix
    ./modules/wrapScripts.nix
    # add more generic modules here
  ];
}
