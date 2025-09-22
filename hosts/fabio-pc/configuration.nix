{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../configuration-common.nix
    ../modules/nvidia.nix
    ../modules/userFabio.nix

    # (import ../modules/syncthing {
    #   user = "fabio";
    #   hostName = "simon-laptop";
    # })
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "fabio-pc";

  system.stateVersion = "25.11";
}
