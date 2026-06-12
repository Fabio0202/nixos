{ config
, pkgs
, ...
}: {
  # `light` was removed in nixpkgs 26.05 due to being unmaintained.
  # brightnessctl is provided via home-manager packages as a replacement.
  hardware.brillo.enable = true;
}
