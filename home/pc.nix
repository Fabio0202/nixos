{ pkgs, ... }:
let 
username = "fabio";
homeDirectory = "/home/${username}";
in 
{
  programs.zsh.enable = true;
  programs.zsh.initExtra = ''
    echo "Welcome to PC!"
  '';
  home = {
    inherit username;
    inherit homeDirectory;
    stateVersion = "25.11";
  };
}