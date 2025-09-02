{
  config,
  pkgs,
  ...
}: {
  # Stylix konfigurieren
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.image = ../../files/wallpapers/space.jpg; # Dein Wallpaper
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml"; # Dein Farbschema
  stylix.targets.grub.enable = true;
  stylix.targets.gtk.enable = true;
  # stylix.targets.spicetify.enable = true;  # Optional, wenn du Spicetify nutzen möchtest
}
