{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hyprland.nix
    #./swaylock.nix
    ./waybar.nix
    ./swaync.nix
    ./swayosd.nix
    ./wlogout.nix
    ./config/default.nix
    ./hyprlock.nix
    ./swww.nix
    # ./hypridle.nix
    ./variables.nix
  ];

  home.packages = with pkgs; [
    libnotify # User-level notifications
    playerctl # Media control via DBus which is a message bus system, a way for applications to talk to each other
    uwsm # unified wayland session management - better compatibility layer for XWayland apps
  ];
}
