{pkgs, ...}: {
  home.packages = with pkgs; [
    # alle Software die ich nur am Stand-PC haben will
  ];
  imports = [
    ./common.nix
    ./common-gui.nix
    ../common.nix
    ../modules/gitFabio.nix
    ../modules/logitech-tastatur.nix
  ];

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "de, us";
    # mouse ssensitivity
    sensitivity = 1.4;
  };
}
