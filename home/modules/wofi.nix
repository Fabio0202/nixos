{...}: {
  programs.wofi = {
    enable = true;
  };

  home.file.".config/wofi" = {
    source = builtins.path {path = ../configfiles/wofi;};
    recursive = true;
  };
}
