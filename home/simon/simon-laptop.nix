{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./common.nix
    ./common-gui.nix
    ../common.nix
    ../modules/battery-monitor.nix
    ../modules/gitSimon.nix
  ];

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "us, de";
    sensitivity = 1.4;
  };
}
