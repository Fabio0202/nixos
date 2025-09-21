{
  pkgs,
  pkgs-unstable,
  ...
}: let
  username = "simon";
  homeDirectory = "/home/${username}";
in {
  # I need to permit insecure packages because of logseq for now
  home.packages = with pkgs; [
  ];

  imports = [
    ./common.nix
    ../common.nix
    ../modules/gitSimon.nix
  ];

  home = {
    inherit username;
    inherit homeDirectory;
    stateVersion = "25.11";
  };
}
