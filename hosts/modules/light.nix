{
  config,
  pkgs,
  ...
}: {
  # `light` is a program for managing screen brightness that interacts directly with hardware.
  # Needs root permissions to function properly, so it’s set up here at the system level.
  programs.light.enable = true;
  hardware.brillo.enable = true;
}
