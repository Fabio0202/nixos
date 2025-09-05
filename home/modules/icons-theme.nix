{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    glib
    gnome-settings-daemon
    gtk3
    gtk4
    gnome-themes-extra
    whitesur-gtk-theme
    whitesur-icon-theme
    rose-pine-cursor # Add this package
  ];

  # gtk = {
  #   enable = true;
  #
  #   theme = {
  #     name = "WhiteSur-Dark";
  #     package = pkgs.whitesur-gtk-theme;
  #   };
  #
  #   iconTheme = {
  #     name = "WhiteSur";
  #     package = pkgs.whitesur-icon-theme;
  #   };
  #
  #   # Changed to Rose Pine cursor
  #   cursorTheme = {
  #     name = "rose-pine-cursor";
  #     package = pkgs.rose-pine-cursor;
  #     size = 24;
  #   };
  #
  #   gtk3.extraConfig = {
  #     gtk-application-prefer-dark-theme = 1;
  #     gtk-theme-name = "WhiteSur-Dark";
  #     gtk-icon-theme-name = "WhiteSur";
  #     gtk-cursor-theme-name = "rose-pine-cursor"; # Updated
  #     gtk-cursor-theme-size = 24;
  #   };
  #
  #   gtk4.extraConfig = {
  #     gtk-application-prefer-dark-theme = 1;
  #     gtk-theme-name = "WhiteSur-Dark";
  #     gtk-icon-theme-name = "WhiteSur";
  #     gtk-cursor-theme-name = "rose-pine-cursor"; # Updated
  #     gtk-cursor-theme-size = 24;
  #   };
  # };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = lib.mkDefault "prefer-dark";
    gtk-theme = lib.mkDefault "WhiteSur-Dark";
    icon-theme = lib.mkDefault "WhiteSur";
    cursor-theme = lib.mkDefault "rose-pine-cursor";
    cursor-size = lib.mkDefault 24;
  };

  home.sessionVariables = {
    GTK_THEME = lib.mkDefault "WhiteSur-Dark";
    XCURSOR_THEME = lib.mkDefault "rose-pine-cursor";
    XCURSOR_SIZE = lib.mkDefault "24";
    NIXOS_OZONE_WL = lib.mkDefault "1";
    ELECTRON_OZONE_PLATFORM_HINT = lib.mkDefault "auto";
    QT_STYLE_OVERRIDE = lib.mkDefault "gtk2";
    QT_QPA_PLATFORMTHEME = lib.mkDefault "gtk2";
  };

  services.gnome-keyring.enable = true;
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
}
