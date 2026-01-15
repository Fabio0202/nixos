{pkgs, ...}: {
  home.packages = with pkgs; [
    # alle Software die ich nur am Laptop haben will
  ];
  imports = [
    ./common.nix
    ./common-gui.nix
    ../common-gui.nix # GUI-only apps and modules
    ../common-server.nix # universal CLI + shared stuff
    ../modules/battery-monitor.nix
    ../modules/gitFabio.nix
  ];

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
