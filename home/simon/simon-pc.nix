{
  pkgs,
  pkgs-unstable,
  ...
}: {
  # I need to permit insecure packages because of logseq for now
  home.packages = with pkgs; [
    sunshine
    # alle Software die ich nur am Laptop haben will
    # TODO: allow unstable imports
    # (pkgs-unstable.vintagestory)
    # (pkgs-unstable.mongodb-compass)
  ];

  imports = [
    ../modules/hyprland/hypridle.nix
    ../modules/gitSimon.nix
    ./common.nix
    ./common-gui.nix
    ../common.nix
  ];

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "us, de";
    sensitivity = 1.4;
  };
}
