{pkgs, ...}: let
  # Define the script as a derivation
  toggleRofiScript = pkgs.writeScriptBin "toggle-rofi" ''
    #!/bin/bash

    if pgrep -x "rofi" > /dev/null; then
      pkill -x rofi
    else
      rofi -show combi -combi-modi "window,drun" -modi combi
    fi
  '';
in {
  environment.systemPackages = [
    toggleRofiScript
  ];

  wayland.windowManager.hyprland.settings.bind = [
    "${mainMod}, Return, exec, ${toggleRofiScript}/bin/toggle-rofi"
  ];
}
