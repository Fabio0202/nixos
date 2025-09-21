{
  pkgs,
  pkgs-unstable,
  ...
}: let
  username = "simon";
  homeDirectory = "/home/${username}";
in {
  # I need to permit insecure packages because of logseq for now
  home.packages = with pkgs; [
    # alle Software die ich nur am Laptop haben will
    # TODO: allow unstable imports
    # (pkgs-unstable.vintagestory)
    # (pkgs-unstable.mongodb-compass)
  ];

  imports = [
    ./common.nix
    ../common.nix
    ../modules/battery-monitor.nix
    ../modules/hyprland/hypridle.nix
    ../modules/gitSimon.nix
  ];

  home = {
    inherit username;
    inherit homeDirectory;
    stateVersion = "25.11";
  };

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "us, de";
    sensitivity = 1.4;
  };
}
