{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/hardware.nix
    ./modules/hyprlandWM.nix
    ./modules/stylix.nix
    ./modules/podman.nix
    ./modules/nix-ld.nix
    ./modules/python.nix
    ./modules/javascript.nix
    ./modules/tailscale.nix
    ./modules/locale.nix
    ./modules/audio.nix
    ./modules/graphics.nix
    ./modules/bluetooth.nix
    ./modules/energy-management.nix
    ./modules/environment-variables.nix
    ./modules/fonts.nix
    ./modules/gaming.nix
    ./modules/gc.nix
    ./modules/light.nix
    ./modules/networking.nix
    ./modules/swap.nix
    ./modules/system.nix
  ];

  boot.plymouth = {
    enable = true;
    themePackages = [pkgs.catppuccin-plymouth];
    theme = "catppuccin-macchiato";
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    steam-run
    papirus-icon-theme
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.firefox.enable = true;
  programs.zsh.enable = true;

  services.printing.enable = true;
}
