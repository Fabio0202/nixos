{
  pkgs,
  inputs,
  ...
}: {
  # Include user-specific packages via Home Manager
  home.packages = with pkgs; [
    hyprpanel
    # Grimblast: Enhanced screenshot tool for Wayland (commented out here, might be used later)
    hyprpicker # Color picker tool compatible with Hyprland
    grim # Screenshot utility for Wayland, works well with slurp for selective screenshots
    slurp # Selection tool for Wayland, often used with grim to capture selected screen regions
    wl-clip-persist # Clipboard manager for Wayland, keeps clipboard content after the app closes
    wf-recorder # Screen recording tool for Wayland, compatible with Hyprland
    hyprcursor
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default # Rose Pine cursor theme for Hyprland
    wl-clipboard
    wlinhibit # User-space inhibitor
    hyprlock # lock screen
    hyprsunset # bluelight filter I think

    hyprpicker # color picker I think
    glib # Core library providing data structure handling, portability, and utility functions

    # some hyprpanel dependencies
    # bluez-utils #appearently doesnt exist?
    bluez
    dart-sass
    gvfs
    libgtop
    python3Packages.dbus-python

    #gnome panel because hyprpanel is buggy af for now
    nwg-panel
  ];

  home.file.".config/nwg-panel" = {
    source = builtins.path {path = ../../configfiles/nwg-panel;};
    recursive = true;
  };

  # Configure the Dunst notification daemon to start automatically with the user session
  # services.dunst.enable = true;
  #
  # # Configure Dunst to run as a user service, using systemd in Home Manager
  # systemd.user.services.dunst = {
  #   description = "Dunst Notification Daemon"; # Description for the systemd service
  #   wantedBy = ["default.target"]; # Start with the user session by default
  #   serviceConfig = {
  #     ExecStart = "${pkgs.dunst}/bin/dunst"; # Path to the Dunst executable
  #   };
  # };
}
