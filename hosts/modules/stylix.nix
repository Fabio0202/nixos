{ config
, pkgs
, ...
}: {
  stylix.enable = true;

  stylix.homeManagerIntegration.autoImport = true;
  stylix.autoEnable = false; # don't auto-enable everything
  stylix.image = null; # no wallpaper control
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark";
  stylix.targets.gtk.enable = true;

  stylix.targets.grub.enable = true;
  stylix.targets.plymouth.enable = false;
  stylix.targets.gnome.enable = false;
}
