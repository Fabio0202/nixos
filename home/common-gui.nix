{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  ...
}: let
  homeDir = config.home.homeDirectory;
in {
  home.activation.stowDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${pkgs.stow}/bin/stow -d ${homeDir}/nixos/dotfiles -t ${homeDir} stow-common zsh ssh --restow
  '';

  home.packages = with pkgs; [
    blueman # GTK-based Bluetooth manager
    nautilus # GNOME file manager
    sioyek # PDF and document viewer
    mpv # Media player (video/audio) with wide codec support
    viewnior # Simple, fast image viewer
    stow # GNU Stow for dotfiles management
    rofi
    bluetuith # TUI bluetooth manager
    pulsemixer # TUI audio mixer
    wtype # Wayland text typing (used by voice dictation)
    sox # Audio recording/processing (used by voice dictation)
    bruno # Open-source API client
    # audacious # Simple and lightweight music player
    # (pkgs-unstable.kdePackages.kdeconnect-kde)
  ];

  services.blueman-applet.enable = true; # Enable system tray applet for Bluetooth

  # MPV configuration (enable settings in Home Manager)
  programs.mpv.enable = true;

  # GUI/desktop modules
  imports = [
    ./modules/obs-studio.nix # Screen recording & streaming setup (OBS Studio)
    ./modules/hyprland/default.nix # Hyprland WM settings (Wayland tiling compositor)
    ./modules/icons-theme.nix # Icon theme configuration for GTK/desktop apps
    # ./modules/nwg-dock.nix # Dock/panel (like a taskbar for Wayland)
    ./modules/dms-night-mode.nix # Night mode via DMS (replaces hyprsunset)
    ./modules/neovim/latex.nix
    # ./modules/hyprsettings.nix # HyprSettings GUI configurator for Hyprland
    ./modules/theme-defaults.nix # Creates default theme symlinks on fresh clones
  ];

  # Set GUI default applications (MIME associations) — non-browser defaults
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/*" = ["mpv.desktop"]; # Use mpv for all video files
      "audio/*" = ["audacious.desktop"]; # Use Audacious for audio
      "image/*" = ["viewnior.desktop"]; # Use Viewnior for images
      "application/pdf" = ["sioyek.desktop"]; # Okular as PDF viewer
    };
  };
}
