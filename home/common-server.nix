{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.packages = with pkgs; [
    syncthing # Sync files across devices automatically
    dysk # Show disk usage (like df but nicer)
    distrobox # Run other Linux distros inside containers
    wine # Run Windows programs on Linux
    ncdu # Visualize disk usage per folder
    btop

    direnv # Manage environment variables per project directory
    unzip # Extract .zip archives
    deno # Modern JavaScript/TypeScript runtime
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

  imports = [
    ./modules/neovim/neovim.nix
    ./modules/sh.nix
    ./modules/ssh.nix
    ./modules/wrapScripts.nix
    # add more generic modules here
  ];
}
