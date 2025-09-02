{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nwg-dock-hyprland
  ];

  home.file.".config/nwg-dock-hyprland/" = {
    source = builtins.path {path = ../configfiles/nwg-dock-hyprland;};
    recursive = true;
  };
}
