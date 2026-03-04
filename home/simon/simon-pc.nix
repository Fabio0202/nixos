{
  pkgs,
  inputs,
  pkgs-unstable,
  ...
}: {
  # I need to permit insecure packages because of logseq for now
  # not sure if I wanna go the winboat route rn lets see
  # home.packages = with pkgs; [
  #   pkgs-unstable.freerdp
  #   pkgs-unstable.winboat
  # ];

  imports = [
    ../modules/gitSimon.nix
    ./common.nix
    ./common-gui.nix
    ../common.nix
  ];
}
