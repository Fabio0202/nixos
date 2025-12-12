{ pkgs, ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      tailscale = prev.tailscale.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];

  services.tailscale = {
    enable = true;
    package = pkgs.tailscale;
  };
}
