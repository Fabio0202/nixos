{pkgs, ...}: {
  home.packages = with pkgs; [
    wlogout
  ];

  home.file.".config/wlogout/" = {
    source = builtins.path {path = ../../configfiles/wlogout;};
    recursive = true;
  };
}
