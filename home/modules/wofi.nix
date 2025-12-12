{ pkgs, ... }: {
  programs.wofi = {
    enable = true;
  };

  home.file.".config/wofi" = {
    source = builtins.path { path = ../configfiles/wofi; };
    recursive = true;
  };

  home.packages = with pkgs; [
    # papirus-icon-theme
    adwaita-icon-theme
  ];
}
