{pkgs, ...}: {
  programs.rofi = {
    enable = true;
  };

  home.file.".config/rofi" = {
    source = builtins.path {path = ../configfiles/rofi;};
    recursive = true;
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
  ];
}
