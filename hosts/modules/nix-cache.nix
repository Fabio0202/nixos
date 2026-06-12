{ ... }: {
  # Hyprland and its plugins are fetched directly from GitHub (not nixpkgs),
  # so they don't have pre-built binaries in the default NixOS cache.
  # Without this, every flake update recompiles Hyprland + plugins from source,
  # which takes a long time. The Hyprland project provides a Cachix cache
  # with pre-built binaries to avoid this.
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
