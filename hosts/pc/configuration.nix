# configuration.nix
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Importiere das xserver-gnome Modul
    ../modules/gnome.nix
  ];

  # Bootloader und Kernel-Konfigurationen bleiben unverändert
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  # Netzwerkmanager und Zeitzone
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Vienna";

  # Internationale Einstellungen
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Benutzer- und Paketkonfigurationen
  users.users.fabio = {
    isNormalUser = true;
    description = "Fabio";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Installiere Firefox
  programs.firefox.enable = true;

  # Erlaube unfreie Pakete
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.experimental-features = "nix-command flakes";

  # Systempakete
  environment.systemPackages = with pkgs; [
    #  vim
    #  wget
  ];

  # Zsh konfigurieren
  programs.zsh.enable = true;

  # Weitere Dienste wie CUPS und Pipewire
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Systemversion
  system.stateVersion = "25.11";
}
