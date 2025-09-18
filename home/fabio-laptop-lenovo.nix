{pkgs, ...}: let
  username = "fabio";
  homeDirectory = "/home/${username}";
in {
  home.packages = with pkgs; [
    # alle Software die ich nur am Laptop haben will
  ];
  imports = [
    ./common.nix
    ./modules/battery-monitor.nix
    ./modules/hyprland/hypridle.nix
    ./modules/gitFabio.nix
  ];
  home = {
    inherit username;
    inherit homeDirectory;
    stateVersion = "25.11";
  };

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "de, us";
    # mouse ssensitivity
    sensitivity = 1.4;
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      # Laptop screen: 1920x1080 at position 0,0
      "eDP-1,1920x1080@60,0x0,1"

      # External monitor: 1920x1080 at position 1920,0
      "DP-1,1920x1080@60,1920x0,1"
    ];
  };
}
