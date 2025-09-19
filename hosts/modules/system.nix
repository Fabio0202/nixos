{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  # nixpkgs-unstable.config.allowUnfree = true;

  # make sure I can still ssh into emergency mode
  systemd.enableEmergencyMode = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # TODO: this should be a separate module for servers to import
  services.openssh = {
    # make sure I can still ssh into emergency mode
    startWhenNeeded = true;
    enable = true;
    forwardX11 = true;
  };
  programs.ssh.startAgent = true;
}
