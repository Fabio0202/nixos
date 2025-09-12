{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.packages = with pkgs; [
    syncthing # Sync files across devices automatically
    obsidian # Markdown-based note-taking & knowledge management
    dysk # Show disk usage (like df but nicer)
    distrobox # Run other Linux distros inside containers
    wine # Run Windows programs on Linux
    ncdu # Visualize disk usage per folder
    libreoffice # Office suite (Word, Excel, etc.)
    unzip # Extract .zip archives
    anki # Flashcard-based learning tool (spaced repetition)
    deno # Modern JavaScript/TypeScript runtime
    blueman # Bluetooth manager for Linux
    imagej # Scientific image analysis (popular in research)
    gimp3-with-plugins # Advanced image editing (Photoshop alternative)
    drawio # Diagram and flowchart creation
    gnome-clocks # World clocks, stopwatch, timers, alarms
    qalculate-gtk # Powerful calculator with many features
    nautilus # GNOME file manager
    blender # 3D modeling, animation, rendering
    kdePackages.kdeconnect-kde # Integrate phone with PC (notifications, file sharing, SMS)
    veusz # Scientific plotting and graphing tool
    todoist # Task management & to-do list app
    xdg-utils # Open files/URLs with default desktop apps
    discord # Voice, video, and text chat (gaming/community)
    evince # Lightweight PDF and document viewer
    audacious # Simple and lightweight music player
    mpv # Media player (video/audio) with wide codec support
    viewnior # Simple, fast image viewer
    neofetch # Show system info in terminal (ASCII art + specs)
    ffmpeg # Convert, edit, and process video/audio files
    git # Version control system
    neovim # Terminal-based text editor (Vim improved)
    vscode # Code editor with GUI (Visual Studio Code)
    lazygit # TUI interface for Git
    spotify # Music streaming client
    sqlite # Lightweight relational database engine
    hyprsunset # Screen color temperature adjustment for eye comfort
  ];

  services.blueman-applet.enable = true;

  # TODO: was macht das? googlen und kommetar adden
  fonts.fontconfig.enable = true;

  # Enable MPV configuration
  programs.mpv.enable = true;

  # Enable XDG MIME application settings
  xdg.mimeApps = {
    enable = false;
    defaultApplications = {
      "video/*" = ["mpv.desktop"];
      "audio/*" = ["audacious.desktop"];
      "image/*" = ["viewnior.desktop"];
      "application/pdf" = ["evince.desktop"];
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };
  };
  imports = [
    ./modules/neovim/neovim.nix
    ./modules/obs-studio.nix # for screen recording
    ./modules/hyprland/default.nix
    ./modules/scripts.nix
    ./modules/sh.nix
    ./modules/icons-theme.nix
    ./modules/wofi.nix
    ./modules/nwg-dock.nix
    ./modules/rofi.nix
    ./modules/show-binds/default.nix
    ./modules/wrapScripts.nix
    ./modules/sunset-at-night.nix
    # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
  ];
}
