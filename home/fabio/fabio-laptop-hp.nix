{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    # alle Software die ich nur am Laptop haben will
  ];
  programs.dank-material-shell = {
    enable = true;
    dgop.package = pkgs-unstable.dgop;
  };

  imports = [
    ./common.nix
    ./common-gui.nix
    ../common-gui.nix # GUI-only apps and modules
    ../common-server.nix # universal CLI + shared stuff
    ../modules/battery-monitor.nix
    ../modules/gitFabio.nix
    inputs.dms.homeModules.dank-material-shell
  ];

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "de, us";
    # mouse ssensitivity
    sensitivity = 1.4;
  };
}
