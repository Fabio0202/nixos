{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../configuration-common.nix
    ../modules/userSimon.nix
    # ../modules/bootloader.nix
    ../modules/grub.nix

    (import ../modules/syncthing {
      user = "simon";
      hostName = "simon-laptop";
    })
  ];

  fileSystems."/mnt/server" = {
    device = "simon-server:/mnt/drive";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "nofail" "x-systemd.idle-timeout=10s" "bg"];
  };

  fileSystems."/mnt/cloud" = {
    device = "simon-server:/mnt/drive/cloud/simon";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "nofail" "x-systemd.idle-timeout=10s" "bg"];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-7.0.20"
  ];
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/nvme0n1";
  # boot.loader.grub.useOSProber = true;

  networking.hostName = "simon-pc";

  system.stateVersion = "25.11";
  # Udev rule to skip initializing the internal smartcard reader
  # → Fixes ~11s boot delay caused by the Alcor AU9540
  # Vendor ID 058f, Product ID 9540 (specific to this device)
  services.udev.extraRules = ''
    # Block the Alcor AU9540 Smartcard Reader (VID: 058f, PID: 9540) immediately at creation
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="058f", ATTR{idProduct}=="9540", \
      ATTR{authorized_default}="0"
  '';
}
