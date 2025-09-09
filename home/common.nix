{pkgs, ...}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.packages = with pkgs; [
    syncthing
    obsidian
    dysk # zeigt wieviel Speicher frei ist auf Festplatte
    distrobox # distrobox enter ubuntu dann bist du in dem terminal in ubuntu virtuell drin
    wine # for windows programs
    ncdu #Welcher Folder wieviel Speicher
    libreoffice
    unzip
    anki
    blueman
    imagej
    gimp3-with-plugins

    #timer app usw

    gnome-clocks

    # calculator, hat mehr funktionen
    qalculate-gtk
    # wenn du lieber wieder gnome-calculator verwenden willst
    # unkommentiere folgende zeile
    #gnome-calculator

    nautilus
    blender
    kdePackages.kdeconnect-kde
    veusz
    todoist
    xdg-utils
    discord
    evince # ein pdf viewer
    audacious # Audio player
    mpv #ein video player

    viewnior # Image viewer
    neofetch
    # ffmpeg # videodateien formatieren und bearbeiten
    libreoffice
    git
    neovim
    vscode
    # libnotify # für Notifications
    lazygit
    spotify
    sqlite

    # nachtmodus programme
    # TODO: eins nur behalten sollte reichen
    # wlsunset
    hyprsunset # seems like wlsunset is not doing its job on the pc?
  ];

  services.blueman-applet.enable = true;

  # TODO: was macht das? googlen und kommetar adden
  fonts.fontconfig.enable = true;

  # Enable MPV configuration
  programs.mpv.enable = true;

  # Enable XDG MIME application settings
  xdg.mimeApps.enable = true;
  # Define default applications for file types
  # xdg.mimeApps.defaultApplications = {
  #   "video/*" = ["mpv.desktop"]; # Default video player
  #   "audio/*" = ["audacious.desktop"]; # Default audio player
  #   "image/*" = ["viewnior.desktop"]; # Default image viewer
  #   "application/pdf" = ["evince.desktop"]; # Default PDF viewer
  #   "text/html" = ["firefox.desktop"]; # Default browser for HTML links
  #   "x-scheme-handler/http" = ["firefox.desktop"]; # For HTTP links
  #   "x-scheme-handler/https" = ["firefox.desktop"]; # For HTTPS links
  # };
  imports = [
    ./modules/neovim/neovim.nix
    ./modules/obs-studio.nix # for screen recording
    ./modules/hyprland/default.nix
    ./modules/scripts.nix
    ./modules/sh.nix
    ./modules/icons-theme.nix
    ./modules/wofi.nix
    ./modules/nwg-dock.nix
    ./modules/git.nix
    # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
  ];
}
