{pkgs, ...}: {
  home.packages = with pkgs; [
    swaylock # to lock your session (manually or automatically)
  ];

  home.file.".config/swaylock/" = {
    source = builtins.path {path = ../../configfiles/swaylock;};
    recursive = true;
  };
}
