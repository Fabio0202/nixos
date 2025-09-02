{
  config,
  pkgs,
  ...
}: let
  gesturesConfig = ''
    # Four-finger swipe for workspace switching
    swipe right 4 hyprctl dispatch workspace next
    swipe left 4 hyprctl dispatch workspace prev

    # Three-finger swipe for app focus
    swipe right 3 hyprctl dispatch focuswindow next
    swipe left 3 hyprctl dispatch focuswindow prev
  '';
in {
  # Add libinput-gestures to the home packages
  home.packages = [pkgs.libinput-gestures];

  # Write the libinput-gestures configuration file
  xdg.configFile."libinput-gestures.conf".text = gesturesConfig;

  # # Enable libinput-gestures as a systemd service for the user
  # systemd.user.services.libinput-gestures = {
  #   description = "Libinput Gestures Service";
  #   wantedBy = [ "default.target" ];
  #
  #   # Start libinput-gestures on login
  #   serviceConfig = {
  #     ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures-setup start";
  #     ExecStop = "${pkgs.libinput-gestures}/bin/libinput-gestures-setup stop";
  #   };
  # };

  # Optional: Ensure user is in the input group to access input devices
  # users.users.${config.home.username}.extraGroups = [ "input" ];
}
