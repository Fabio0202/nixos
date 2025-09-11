{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override {
      rofi-unwrapped = pkgs.rofi-wayland-unwrapped.overrideAttrs (old: {
        configureFlags = (old.configureFlags or []) ++ ["--enable-script"];
      });
    };
  };

  home.file.".config/rofi" = {
    source = builtins.path {path = ../configfiles/rofi;};
    recursive = true;
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
  ];
}
