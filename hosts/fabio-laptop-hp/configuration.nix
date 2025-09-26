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
    (import ../modules/syncthing {
      user = "fabio";
      hostName = "fabio";
    })
  ];

  fileSystems."/mnt/cloud" = {
    device = "server-wien:/mnt/drive/cloud/fabio";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "nofail" "x-systemd.idle-timeout=10s" "bg" "x-systemd.requires=network-online.target" "x-systemd.after=network-online.target"];
  };
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/nvme0n1";
  # boot.loader.grub.useOSProber = true;

  networking.hostName = "fabio-laptop-hp";

  system.stateVersion = "25.11";
}
