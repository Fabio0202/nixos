{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # make sure I can still ssh into emergency mode
  systemd.enableEmergencyMode = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  services.openssh = {
    # make sure I can still ssh into emergency mode
    startWhenNeeded = true;
    enable = true;
    forwardX11 = true;
  };
}
