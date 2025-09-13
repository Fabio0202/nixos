{pkgs, ...}: let
  username = "fabio";
  homeDirectory = "/home/${username}";
in {
  home.packages = with pkgs; [
    # alle Software die ich nur am Stand-PC haben will
  ];
  imports = [
    ./common.nix
    ./modules/gitFabio.nix

    ./modules/logitech-tastatur.nix
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
}
