{
  config,
  pkgs,
  ...
}: {
  stylix.enable = true;
  stylix.autoEnable = true;

  # Wallpaper
  stylix.image = ../../files/wallpapers/space.jpg;

  # Use Catppuccin Mocha color scheme (dark variant)
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark"; # explicitly prefer dark styling

  # Targets
  stylix.targets.grub.enable = true;
  stylix.targets.plymouth.enable = false;
  stylix.targets.gtk.enable = true;
  # stylix.targets.spicetify.enable = true; # optional
}
