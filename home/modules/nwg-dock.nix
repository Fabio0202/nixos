{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nwg-dock-hyprland
  ];

  # Hier ist die Ddocumentation
  # mache zum bearbeiten die nwg-dock file in configfiles auf
  # https://github.com/nwg-piotr/nwg-dock-hyprland
  home.file.".config/nwg-dock-hyprland/" = {
    source = builtins.path {path = ../configfiles/nwg-dock-hyprland;};
    recursive = true;
  };

  home.file.".cache/nwg-dock-pinned" = {
    source = ../configfiles/nwg-dock-hyprland/pinned;
  };
}
