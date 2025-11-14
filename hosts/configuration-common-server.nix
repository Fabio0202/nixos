{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/hardware.nix
    ./modules/podman.nix # containers
    ./modules/nix-ld.nix # dynamic linker support for binaries
    ./modules/python.nix # optional dev/runtime
    ./modules/javascript.nix # optional dev/runtime
    ./modules/tailscale.nix # networking/VPN
    ./modules/locale.nix # locales/timezone
    ./modules/fonts.nix # fonts (needed if you run services generating PDFs/images)
    ./modules/gc.nix # nix garbage collection policies
    ./modules/networking.nix # firewall, interfaces, etc.
    ./modules/swap.nix # swap configuration
    ./modules/system.nix # systemd, user services, etc.
  ];

  # Servers typically don’t need Plymouth splash
  boot.plymouth.enable = false;

  #docker because you need docker on your servers of course
  virtualisation.docker.enable = true;
  # Stick with stable kernel unless you need bleeding-edge hardware support
  # (safer for servers)
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages;

  # GUI/browser not needed on headless server
  # programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Enable printing only if your server actually has/needs CUPS
  services.printing.enable = false;
}
