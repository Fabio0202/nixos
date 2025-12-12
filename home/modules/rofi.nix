{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi; # rofi-wayland merged into rofi in 25.11
  };

  home.file.".config/rofi" = {
    source = builtins.path { path = ../configfiles/rofi; };
    recursive = true;
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
  ];
}
