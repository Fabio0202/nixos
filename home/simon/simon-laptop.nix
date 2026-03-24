{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: let
  homeDir = config.home.homeDirectory;
in {
  imports = [
    ./common.nix
    ./common-gui.nix
    ../common.nix
    ../modules/battery-monitor.nix
    ../modules/gitSimon.nix
  ];

  # wayland.windowManager.hyprland.settings.input = {
  #   kb_layout = "us, de";
  #   sensitivity = 1.4;
  # };
  xdg.desktopEntries.paper-design = {
    name = "Paper Design";
    exec = "appimage-run ${homeDir}/Downloads/paper-desktop-0.1.10x86_64.AppImage %u";
    terminal = false;
    mimeType = ["x-scheme-handler/paper"];
    categories = ["Development"];
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/paper" = ["paper-design.desktop"];
  };
}
