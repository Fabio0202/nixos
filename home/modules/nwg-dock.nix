{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nwg-dock-hyprland
  ];

  # NOTE: nwg-dock styling is now managed via stow in ~/.config/nwg-dock-hyprland/
  # Configuration moved to dotfiles/stow-common/.config/nwg-dock-hyprland/
  # Themes are now managed by the 'theme' script like other applications
}
