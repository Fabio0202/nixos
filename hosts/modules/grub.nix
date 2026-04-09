{ pkgs, ... }: {
  boot.loader.systemd-boot.enable = false; # disable systemd-boot
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev"; # EFI-only, no MBR install
    efiSupport = true;
    useOSProber = true; # detects Windows, other Linux installs
    theme = pkgs.nixos-grub2-theme;
  };
}
