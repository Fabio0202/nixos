{ config
, lib
, pkgs
, ...
}:
let
  # available themes:
  # astronaut.conf
  # black_hole.conf
  # cyberpunk.conf
  # hyprland_kath.conf
  # jake_the_dog.conf
  # japanese_aesthetic.conf
  # pixel_sakura.conf
  # pixel_sakura_static.conf
  # post-apocalyptic_hacker.conf
  # purple_leaves.conf
  # https://github.com/Keyitdev/sddm-astronaut-theme
  # Use the override function to configure the theme
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "purple_leaves"; # This should match the variant name without .conf
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";

    settings = {
      Theme = {
        Current = "sddm-astronaut-theme";
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

  # Add the customized theme to extraPackages
  services.displayManager.sddm.extraPackages = with pkgs; [
    custom-sddm-astronaut
    kdePackages.qtmultimedia
    kdePackages.qtsvg
    kdePackages.qtvirtualkeyboard
  ];

  # Set environment variables for the display manager service
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
    custom-sddm-astronaut
    qt6.qtwayland
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtdeclarative
    qt6.qtvirtualkeyboard
    qt6.qtquick3d
    pipewire
    ffmpeg
  ];

  services.dbus.enable = true;
  security.polkit.enable = true;
}
