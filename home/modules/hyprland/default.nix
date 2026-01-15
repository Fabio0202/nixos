{
  inputs,
  pkgs,
  ...
}: {
  # DISABLED: Using traditional dotfiles with GNU Stow instead
  # Configuration is now in ~/dotfiles/stow-common/hyprland/.config/hypr/
  imports = [
    ./hyprland.nix # Keep for package installation only
    #./swaylock.nix
    ./waybar.nix

    ./swaync.nix
    ./swayosd.nix

    ./config/default.nix # Plugin installation (config via stow)
    ./swww.nix
    ./variables.nix
  ];

  home.packages = with pkgs; [
    libnotify # User-level notifications
    playerctl # Media control via DBus which is a message bus system, a way for applications to talk to each other
    uwsm # unified wayland session management - better compatibility layer for XWayland apps
    hyprlock # Screen locker (config via stow)
    hypridle # Idle daemon (config via stow)
  ];
}
