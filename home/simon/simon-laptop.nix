{ pkgs
, inputs
, pkgs-unstable
, config
, ...
}:
let
  homeDir = config.home.homeDirectory;
in
{
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    dgop.package = pkgs-unstable.dgop;
    settings = {
      showLauncherButton = false;
      barConfigs = [{
        id = "default";
        name = "Main Bar";
        leftWidgets = ["workspaceSwitcher" "focusedWindow"];
        centerWidgets = ["music" "clock" "weather"];
        rightWidgets = ["systemTray" "clipboard" "cpuUsage" "memUsage" "notificationButton" "battery" "controlCenterButton"];
      }];
    };
  };

  imports = [
    ./common.nix
    ./common-gui.nix
    ../common.nix
    ../modules/battery-monitor.nix
    ../modules/gitSimon.nix
    ../modules/walker.nix
  ];

  # wayland.windowManager.hyprland.settings.input = {
  #   kb_layout = "us, de";
  #   sensitivity = 1.4;
  # };
  # paper design not really using it right now
  # xdg.desktopEntries.paper-design = {
  #   name = "Paper Design";
  #   exec = "appimage-run ${homeDir}/Downloads/paper-desktop-0.1.10x86_64.AppImage %u";
  #   terminal = false;
  #   mimeType = ["x-scheme-handler/paper"];
  #   categories = ["Development"];
  # };
  # xdg.mimeApps.defaultApplications = {
  #   "x-scheme-handler/paper" = ["paper-design.desktop"];
  # };
}
