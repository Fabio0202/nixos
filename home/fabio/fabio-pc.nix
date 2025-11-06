{
  pkgs,
  inputs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # alle Software die ich nur am Stand-PC haben will

    pkgs-unstable.freerdp
    pkgs-unstable.winboat
  ];
  imports = [
    ./common.nix
    ./common-gui.nix
    ../common-server.nix # universal CLI + shared stuff
    ../common-gui.nix # GUI-only apps and modules
    ../modules/gitFabio.nix
    ../modules/logitech-tastatur.nix
  ];

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "de, us";
    # mouse ssensitivity
    sensitivity = 1.4;
  };
}
