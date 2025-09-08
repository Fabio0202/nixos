{
  lib,
  pkgs,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in {
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.enable = false;
  # services.xserver.displayManager.sddm.enable = true;
  programs.hyprland.enable = true; # Enable the Hyprland window manager
  programs.hyprland.withUWSM = true; # Enable improved hyprland compatibility with uwsm
  # enable greetd to start a session without hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  services.gvfs.enable = true; # gnome virtual file system; falls man zB Server in Files sehen möchte, ausserdem damit trash restore in nautilus file manager geht
  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
  # Create a session file for Hyprland in the Wayland sessions directory
  # This file tells GDM (or other display managers) how to start Hyprland
  environment.etc."wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland                  # Name of the session as it appears in the login manager
    Comment=Start Hyprland Wayland session  # Description for the session
    Exec=Hyprland                  # Command to start Hyprland
    Type=Application               # Type of the desktop entry
    DesktopNames=Hyprland          # Name associated with this desktop session
  '';

  # Remove decorations for QT applications
  environment.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  programs.xwayland.enable = true;

  # Make GTK handle OpenURI; Hyprland handles screencast
  # Moved these options to the top level:
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland # Add this first
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-gnome  # You can remove this if not needed
    ];
    config = {
      common.default = ["hyprland" "gtk"];
      hyprland = {
        default = ["hyprland" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.OpenURI" = ["gtk"];
      };
    };
  };
}
