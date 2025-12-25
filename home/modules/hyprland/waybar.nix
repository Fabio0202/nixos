{pkgs, ...}: {
  home.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    fantasque-sans-mono
    lm_sensors
    networkmanagerapplet

    socat # Required for Hyprland workspace events
    jq # For JSON processing
    playerctl
    waybar
    wlogout
  ];
  # DISABLED: Using stow-managed dotfiles instead
  # home.file.".config/waybar/" = {
  #   source = builtins.path {path = ../../configfiles/waybar;};
  #   recursive = true;
  # };
}
