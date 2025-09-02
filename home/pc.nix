{ pkgs, ... }:

{
  programs.zsh.enable = true;
  programs.zsh.initExtra = ''
    echo "Welcome to PC!"
  '';
}
