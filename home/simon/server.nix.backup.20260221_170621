{
  pkgs,
  pkgs-unstable,
  ...
}: {
  # I need to permit insecure packages because of logseq for now
  home.packages = with pkgs; [
  ];

  imports = [
    ./common.nix
    ../common-server.nix
    ../modules/gitSimon.nix
  ];
}
