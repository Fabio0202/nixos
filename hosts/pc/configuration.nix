# configuration.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../modules/hardware.nix
    # Importiere das xserver-gnome Modul
    # ../modules/gnome.nix
    ../modules/hyprlandWM.nix
    ../modules/user.nix
    ../modules/locale.nix
    ../modules/audio.nix
    ../modules/graphics.nix
    ../modules/nvidia.nix
    ../modules/user.nix
    ../modules/bluetooth.nix
    ../modules/energy-management.nix
    ../modules/environment-variables.nix
    ../modules/fonts.nix
    ../modules/gaming.nix
    ../modules/gc.nix
    ../modules/light.nix
    ../modules/networking.nix
    # ../modules/stylix.nix
    ../modules/swap.nix
    ../modules/system.nix
  ];

  # Bootloader und Kernel-Konfigurationen bleiben unverändert
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;
  boot.plymouth = {
    enable = true;
    themePackages = [pkgs.catppuccin-plymouth];
    theme = "catppuccin-macchiato"; # check the exact dir name in /run/current-system/sw/share/plymouth/themes
    # font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # TODO: Enable Tailscale VPN
  # services.tailscale.enable = true;

  # Add distrobox to the system packages so that it is installed and available.
  environment.systemPackages = with pkgs; [
    distrobox
  ];
  # Installiere Firefox
  programs.firefox.enable = true;

  # Zsh konfigurieren
  programs.zsh.enable = true;

  # Weitere Dienste wie CUPS und Pipewire
  services.printing.enable = true;

  # Systemversion
  system.stateVersion = "25.11";
}
