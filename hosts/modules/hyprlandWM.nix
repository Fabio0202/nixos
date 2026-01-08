{ inputs
, lib
, pkgs
, ...
}: {
  # Disable X11 completely
  services.xserver.enable = false;
  programs.xwayland.enable = true;

  # use latest hyprland from unstable
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # UWSM is required for Hyprland 0.53+ (provides start-hyprland)
    # It properly activates systemd user session and graphical-session.target
    withUWSM = true;
  };

  # force wayland for electron apps
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_LAUNCH_FLAGS = "--enable-wayland-ime --wayland-text-input-version=3 --enable-features=WaylandLinuxDrmSyncobj";
  };

  services.gvfs.enable = true; # gnome virtual file system

  # Remove decorations for QT applications
  environment.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # Make GTK handle OpenURI; Hyprland handles screencast
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-hyprland now auto-included with Hyprland in 25.11
    ];
    config = {
      common.default = [ "hyprland" "gtk" ];
      hyprland = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
      };
    };
  };

  # Import greetd login configuration
  imports = [ ./login.nix ];
}
