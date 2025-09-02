{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hyprland.nix
    #./swaylock.nix
    ./waybar.nix
    ./wlogout.nix
    ./config/default.nix
    ./hyprlock.nix
    ./swww.nix
    ./hypridle.nix
    ./variables.nix
  ];

  home.packages = with pkgs; [
    libnotify # User-level notifications
    playerctl # Media control via DBus which is a message bus system,  a way for applications to talk to each other
    tesseract # this is for  optical character recognition
    uwsm
  ];
}
