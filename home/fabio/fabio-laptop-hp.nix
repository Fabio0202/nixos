{pkgs, ...}: {
  home.packages = with pkgs; [
    # alle Software die ich nur am Laptop haben will
  ];
  imports = [
    ./common.nix
    ./common-gui.nix
    ../common.nix
    ../modules/battery-monitor.nix
    ../modules/hyprland/hypridle.nix
    ../modules/gitFabio.nix
  ];

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "de, us";
    # mouse ssensitivity
    sensitivity = 1.4;
  };
}
