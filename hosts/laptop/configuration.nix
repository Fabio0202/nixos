{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../configuration-common.nix
    ../modules/userFabio.nix
    ../modules/nvidia.nix
    # ../modules/bootloader.nix
    ../modules/grub.nix
    ../modules/syncthing_fabio.nix
  ];

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/nvme0n1";
  # boot.loader.grub.useOSProber = true;

  networking.hostName = "laptop";

  system.stateVersion = "25.11";
}
