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
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "fabio-pc";

  system.stateVersion = "25.11";
}
