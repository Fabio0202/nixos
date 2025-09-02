{
  config,
  pkgs,
  ...
}: {
  # Install packages system-wide
  environment.systemPackages = with pkgs; [
    steam
    mangohud
    protonup
    gamemode
  ];

  # Enable gamemode service system-wide
  # TODO: für später hinzufügen??
  # services.gamemode = {
  #   enable = true;
  # };

  # Enable Steam and gamescope session
  # Note: `programs.steam` does not exist in NixOS directly, so we handle it with packages
  environment.variables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/fabio/.steam/root/compatibilitytools.d";
}
