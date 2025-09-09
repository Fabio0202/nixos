{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../configuration-common.nix
    ../modules/userSimon.nix
    ../modules/bootloader.nix
  ];

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/nvme0n1";
  # boot.loader.grub.useOSProber = true;

  networking.hostName = "simon-laptop";

  system.stateVersion = "25.11";
}
