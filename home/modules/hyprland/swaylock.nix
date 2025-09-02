{pkgs, ...}: {
  home.packages = with pkgs; [
    swaylock
  ];

  home.file.".config/swaylock/" = {
    source = builtins.path {path = ../../configfiles/swaylock;};
    recursive = true;
  };
}
