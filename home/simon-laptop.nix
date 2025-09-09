{pkgs, ...}: let
  username = "simon";
  homeDirectory = "/home/${username}";
in {
  home.packages = with pkgs; [
    # alle Software die ich nur am Laptop haben will
  ];
  imports = [
    ./common.nix
    ./modules/battery-monitor.nix
    ./modules/hyprland/hypridle.nix
    ./modules/gitSimon.nix
  ];
  home = {
    inherit username;
    inherit homeDirectory;
    stateVersion = "25.11";
  };
}
