{ pkgs
, pkgs-unstable
, config
, lib
, nix-search-tv-src
, helium
, self
, ...
}:
let
  homeDir = config.home.homeDirectory;

  ns = pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [ fzf nix-search-tv bat jq ];
    text =
      builtins.replaceStrings
        [ "nix-search-tv print" ]
        [ "nix-search-tv print --indexes nixpkgs" ]
        (builtins.readFile "${nix-search-tv-src}/nixpkgs.sh");
  };

  # Directories containing runtime-mutable files that must NOT be stow directory symlinks.
  # These are pre-created as real dirs so stow symlinks individual files instead.
  mutableDirs = with builtins; map (d: "${homeDir}/.config/${d}") [
    "hypr/themes"
    "kitty/themes"
    "rofi"
    "swaync/themes"
    "swayosd/themes"
    "telegram-themes"
    "waybar/themes"
    "nwg-dock-hyprland"
    "wlogout"
    "dgop"
  ] ++ [
    "${homeDir}/.local/state/DankMaterialShell"
  ];

  # Runtime-mutable theme files that stow must not manage (these belong to theme-defaults).
  # If stow creates a symlink here, we remove it so theme-defaults/theme script can own it.
  mutableFiles = with builtins; map (f: "${homeDir}/.config/${f}") [
    "hypr/themes/current.conf"
    "kitty/themes/current.conf"
    "rofi/config.rasi"
    "swaync/themes/current.css"
    "swayosd/themes/current.css"
    "telegram-themes/current.tdesktop-theme"
    "waybar/themes/current.css"
    "nwg-dock-hyprland/style.css"
    "wlogout/style.css"
    "dgop/colors.json"
  ] ++ [
    "${homeDir}/.local/state/DankMaterialShell/session.json"
  ];
in
{
  home.activation.prepStowDirs = lib.hm.dag.entryBefore [ "stowDotfiles" ] ''
    # Remove old stow symlinks (both old checkout-based and store-based).
    find ${homeDir} -maxdepth 5 -lname "*/nixos/dotfiles/*" -delete 2>/dev/null || true
    find ${homeDir} -maxdepth 5 -type l -lname "*/nix/store/*-source/dotfiles/*" -delete 2>/dev/null || true
    # Remove runtime-mutable files that would block stow from replacing them with symlinks.
    # DMS/theme-script will regenerate these on next run.
    for f in ${lib.escapeShellArgs mutableFiles}; do
      rm -f "$f"
    done
    # Create real directories for dirs that contain runtime-mutable files.
    # This forces stow to symlink individual files, leaving runtime files alone.
    for d in ${lib.escapeShellArgs mutableDirs}; do
      if [ -L "$d" ]; then
        unlink "$d"
      fi
      mkdir -p "$d"
    done
  '';

  home.activation.stowDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.stow}/bin/stow -d ${homeDir}/nixos/dotfiles -t ${homeDir} stow-common zsh ssh --restow --override=stow-common
  '';

  home.activation.fixMutableThemeFiles = lib.hm.dag.entryAfter [ "stowDotfiles" ] ''
    for f in ${lib.escapeShellArgs mutableFiles}; do
      if [ -L "$f" ] && [[ $(readlink "$f") == */nixos/* ]] || [[ $(readlink "$f") == /nix/store/* ]]; then
        rm "$f"
      fi
    done
  '';

  home.sessionVariables.DOTFILES_PATH = self;

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
    bruno # Open-source API client
    ns # nix-search-tv wrapper (packages only)
    newsflash # GTK RSS feed reader
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
    # ./modules/neovim/latex.nix  # removed: nvim-shell replaces nvf
    # ./modules/hyprsettings.nix # HyprSettings GUI configurator for Hyprland
    ./modules/theme-defaults.nix # Creates default theme symlinks on fresh clones
  ];

  # Set GUI default applications (MIME associations) — non-browser defaults
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/*" = [ "mpv.desktop" ]; # Use mpv for all video files
      "audio/*" = [ "audacious.desktop" ]; # Use Audacious for audio
      "image/*" = [ "viewnior.desktop" ]; # Use Viewnior for images
      "application/pdf" = [ "sioyek.desktop" ]; # Okular as PDF viewer
    };
  };
}
