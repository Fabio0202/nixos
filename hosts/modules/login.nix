{
  config,
  lib,
  pkgs,
  ...
}: let
  astronautVariant = "jake_the_dog.conf";
in {
  # ❯ ls /run/current-system/sw/share/sddm/themes/sddm-astronaut-theme/Themes/
  #  astronaut.conf       jake_the_dog.conf          post-apocalyptic_hacker.conf
  #  black_hole.conf      japanese_aesthetic.conf    purple_leaves.conf
  #  cyberpunk.conf       pixel_sakura.conf
  #  hyprland_kath.conf   pixel_sakura_static.conf
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";

    settings = {
      Theme = {
        Current = "sddm-astronaut-theme";
        ConfigFile = "Themes/${astronautVariant}";
      };
      Wayland = {
        EnableHiDPI = true;
      };
      General = {
        InputMethod = "qtvirtualkeyboard";
      };
    };
  };

  environment.etc."sddm/wayland-sessions/hyprland-uwsm.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Comment=Hyprland Wayland compositor
    Exec=${config.programs.hyprland.package}/bin/Hyprland
    Type=Application
    DesktopNames=Hyprland
  '';

  services.displayManager.defaultSession = "hyprland-uwsm";

  # Set environment variables for the display manager service only
  systemd.services.display-manager = {
    serviceConfig = {
      Environment = [
        "QML2_IMPORT_PATH=${lib.concatStringsSep ":" [
          "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
          "${pkgs.qt6.qtmultimedia}/lib/qt-6/qml"
          "${pkgs.qt6.qtvirtualkeyboard}/lib/qt-6/qml"
          "${pkgs.qt6.qtsvg}/lib/qt-6/qml"
          "${pkgs.qt6.qtquick3d}/lib/qt-6/qml"
        ]}"
        "QT_PLUGIN_PATH=${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}"
        "QT_QPA_PLATFORM=wayland"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    sddm-astronaut

    # Required for Astronaut theme animations
    qt6.qtwayland
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtdeclarative
    qt6.qtvirtualkeyboard
    qt6.qtquick3d

    # Backends
    pipewire
    ffmpeg
  ];

  services.dbus.enable = true;
  security.polkit.enable = true;
}
