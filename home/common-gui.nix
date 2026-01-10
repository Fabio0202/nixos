{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # obsidian # Replaced with FHS wrapper for plugin support
    libreoffice # Office suite (Word, Excel, PowerPoint, etc.)
    anki # Flashcard-based learning tool (spaced repetition)
    blueman # GTK-based Bluetooth manager
    gnome-clocks # World clocks, stopwatch, timers, alarms
    qalculate-gtk # Advanced calculator with many features
    nautilus # GNOME file manager
    (pkgs-unstable.kdePackages.kdeconnect-kde)
    discord # Voice, video, and text chat (gaming/community)
    evince # Lightweight PDF and document viewer
    audacious # Simple and lightweight music player
    mpv # Media player (video/audio) with wide codec support
    viewnior # Simple, fast image viewer
    vscode # GUI code editor (Visual Studio Code)
    spotify # Music streaming client
    hyprsunset # Screen color temperature adjustment for eye comfort
    stow # GNU Stow for dotfiles management
    rofi
  ];

  services.blueman-applet.enable = true; # Enable system tray applet for Bluetooth

  # MPV configuration (enable settings in Home Manager)
  programs.mpv.enable = true;

  # GUI/desktop modules
  imports = [
    ./modules/obs-studio.nix # Screen recording & streaming setup (OBS Studio)
    ./modules/hyprland/default.nix # Hyprland WM settings (Wayland tiling compositor)
    ./modules/scripts.nix # Custom user scripts (helpers, automation, etc.)
    ./modules/stylix.nix # Stylix (theme management for GTK, GRUB, etc.)
    ./modules/icons-theme.nix # Icon theme configuration for GTK/desktop apps
    ./modules/wofi.nix # Wofi (Wayland app launcher) setup
    ./modules/nwg-dock.nix # Dock/panel (like a taskbar for Wayland)
    ./modules/show-binds/default.nix # Show keybindings overlay/help popup
    ./modules/sunset-at-night.nix # Color temperature adjustment at night (like redshift)
    ./modules/neovim/latex.nix
    ./modules/hyprsettings.nix # HyprSettings GUI configurator for Hyprland
    ../modules/obsidian-fhs.nix # Obsidian with FHS wrapper for plugin support
  ];

  # Set GUI default applications (MIME associations)
  xdg.mimeApps = {
    enable = false; # Disable Home Manager control over mimeapps.list (can switch to true later)
    defaultApplications = {
      "video/*" = ["mpv.desktop"]; # Use mpv for all video files
      "audio/*" = ["audacious.desktop"]; # Use Audacious for audio
      "image/*" = ["viewnior.desktop"]; # Use Viewnior for images
      "application/pdf" = ["evince.desktop"]; # Evince as PDF viewer
      "text/html" = ["firefox.desktop"]; # Firefox for HTML
      "x-scheme-handler/http" = ["firefox.desktop"]; # HTTP links → Firefox
      "x-scheme-handler/https" = ["firefox.desktop"]; # HTTPS links → Firefox
    };
  };
}
