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

    ../modules/tailscale.nix
    ../modules/sycnthingSimon.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-7.0.20"
  ];
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/nvme0n1";
  # boot.loader.grub.useOSProber = true;

  networking.hostName = "simon-laptop";

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
