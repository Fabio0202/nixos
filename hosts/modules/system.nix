{ config
, pkgs
, ...
}: {
  nixpkgs.config.allowUnfree = true;
  # nixpkgs-unstable.config.allowUnfree = true;

  # make sure I can still ssh into emergency mode
  systemd.enableEmergencyMode = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSeBc="
  ];
  # TODO: this should be a separate module for servers to import
  services.openssh = {
    # make sure I can still ssh into emergency mode
    startWhenNeeded = true;
    enable = true;
    forwardX11 = true;
  };
  programs.ssh.startAgent = true;
}
