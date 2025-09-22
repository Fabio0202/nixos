{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../configuration-common.nix
    ../modules/userFabio.nix
    ../modules/nvidia-fabio-lenovo.nix
    # ../modules/bootloader.nix
    ../modules/grub.nix
    (import ../modules/syncthing {
      user = "fabio";
      hostName = "fabio";
    })
  ];

  fileSystems."/mnt/server" = {
    device = "simon-server:/mnt/drive";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "nofail" "x-systemd.idle-timeout=10s" "bg"];
  };

  fileSystems."/mnt/cloud" = {
    device = "simon-server:/mnt/drive/cloud/fabio";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "nofail" "x-systemd.idle-timeout=10s" "bg"];
  };
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/nvme0n1";
  # boot.loader.grub.useOSProber = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
  networking.hostName = "fabio-laptop-lenovo";

  system.stateVersion = "25.11";
}
