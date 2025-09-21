{pkgs, ...}: {
  imports = [
    ./common.nix # universal CLI + shared stuff
    ./common-gui.nix # GUI-only apps and modules
  ];
}
