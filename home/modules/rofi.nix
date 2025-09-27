{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland; # 👈 use the Wayland fork
  };

  home.file.".config/rofi" = {
    source = builtins.path {path = ../configfiles/rofi;};
    recursive = true;
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
  ];
}
