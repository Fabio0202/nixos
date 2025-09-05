# keybindings.nix
{pkgs, ...}: let
  mainMod = "Super"; # Define Super as the main mod key

  # Define the toggle-rofi script with `writeScriptBin`
  toggleRofiScript = pkgs.writeScriptBin "toggle-rofi" ''
    #!/bin/bash

    if pgrep -x "rofi" > /dev/null; then
      pkill -x rofi
    else
      rofi -show combi -combi-modi "window,drun" -modi combi
    fi
  '';
  # Make the script available as a system package
  environment.systemPackages = [
    toggleRofiScript
  ];
in {
  wayland.windowManager.hyprland.settings.bindm = [
    # Scroll through existing workspaces
    # "${mainMod}, mouse_down, workspace, e+1"
    # "${mainMod}, mouse_up, workspace, e-1"
    # Move/Resize windows with mainMod + LMB/RMB and dragging
    "${mainMod}, mouse:272, movewindow"

    #TODO: fix this resize window option doesn't exist
    "${mainMod}, mouse:273, resizewindow"
    #
  ];
  wayland.windowManager.hyprland.settings.bind = [
    "${mainMod}, mouse_down, workspace, e+1"
    "${mainMod}, mouse_up, workspace, e-1"
    "${mainMod}, Q, exec, hyprctl dispatch killactive"
    "${mainMod}, P, exec, wlogout --buttons-per-row 4"
    "${mainMod}, S, exec, hyprctl switchxkblayout current next"
    "${mainMod}, D, overview:toggle"
    "${mainMod}, delete, exit"
    "${mainMod}, G, togglefloating"
    "${mainMod}, W, exec, waypaper"
    "${mainMod}, M, fullscreen"
    "${mainMod}, return, exec, /home/fabio/nixos/home/scripts/wofi.sh"
    "ALT, return, fullscreen"
    # "${mainMod}, backspace, exec, $scrPath/logoutlaunch.sh 1" # logout menu
    "${mainMod}, T, exec, kitty"
    "${mainMod}, F, exec, nautilus"
    "${mainMod} SHIFT, F, exec, /home/fabio/nixos-dotfiles/scripts/wofi-dir-script.sh"
    "${mainMod}, B, exec, firefox"
    "${mainMod}, C, exec, code"
    "${mainMod}, V, exec, kitty nvim"
    # Rofi toggles
    "${mainMod}, SPACE, exec, /home/fabio/scripts/toggle-wk.sh"
    "${mainMod}, a, exec, pkill -x rofi ; rofi -show window"
    "${mainMod}, ESCAPE, exec, pkill -x rofi ; rofi -show window"
    "${mainMod}, e, exec, pkill -x rofi ; rofi -show drun"

    "ALT SHIFT, J, exec, amixer set Master 10%-"
    "ALT SHIFT, K, exec, amixer set Master 10%+"

    # Audio controls
    ", F1, exec, amixer set Master toggle"
    ", F2, exec, amixer set Master 10%-"
    ", F3, exec, amixer set Master 10%+"

    ", XF86AudioMute, exec, amixer set Master toggle"
    ", XF86AudioMicMute, exec, amixer set Capture toggle"
    ", F4, exec, amixer set Capture toggle"
    ", 190, exec, amixer set Capture toggle"

    ", XF86MonBrightnessUp, exec, light -A 10"
    ", XF86MonBrightnessDown, exec, light -U 10"
    ", XF86AudioLowerVolume, exec, amixer set Master 10%-"
    ", XF86AudioRaiseVolume,  exec, amixer set Master 10%+"
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioPause, exec, playerctl play-pause"
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPrev, exec, playerctl previous"

    # Brightness controls
    ", XF86MonBrightnessUp, exec, light -A 10"
    ", XF86MonBrightnessDown, exec, light -U 10"

    # Screenshot/Screencapture
    "${mainMod}, P, exec, pin"
    "${mainMod} SHIFT, S, exec, sh -c 'grim -g \"$(slurp)\" - | wl-copy'"
    ", Print, exec, sh -c 'grim - | wl-copy && notify-send \"Screenshot\" \"Copied entire screen to clipboard\"'"

    # Move focus with mainMod + arrow keys
    "${mainMod}, H, movefocus, l"
    "${mainMod}, K, movefocus, u"
    "${mainMod}, J, movefocus, d"
    "${mainMod}, L, movefocus, r"
    "${mainMod}, left, movefocus, l"
    "${mainMod}, up, movefocus, u"
    "${mainMod}, down, movefocus, d"
    "${mainMod}, right, movefocus, r"
    "ALT, Tab, movefocus, d"
    "${mainMod}, Tab, exec, ../../../scripts/wofi_keybinds.sh"

    # Switch workspaces
    "${mainMod}, 1, workspace, 1"
    "${mainMod}, 2, workspace, 2"
    "${mainMod}, 3, workspace, 3"
    "${mainMod}, 4, workspace, 4"
    "${mainMod}, 5, workspace, 5"
    "${mainMod}, 6, workspace, 6"
    "${mainMod}, 7, workspace, 7"
    "${mainMod}, 8, workspace, 8"
    "${mainMod}, 9, workspace, 9"
    "${mainMod}, 0, workspace, 10"

    # Move the focused application to the corresponding workspace
    "${mainMod}Shift, 1, movetoworkspace, 1"
    "${mainMod}Shift, 2, movetoworkspace, 2"
    "${mainMod}Shift, 3, movetoworkspace, 3"
    "${mainMod}Shift, 4, movetoworkspace, 4"
    "${mainMod}Shift, 5, movetoworkspace, 5"
    "${mainMod}Shift, 6, movetoworkspace, 6"
    "${mainMod}Shift, 7, movetoworkspace, 7"
    "${mainMod}Shift, 8, movetoworkspace, 8"
    "${mainMod}Shift, 9, movetoworkspace, 9"
    "${mainMod}Shift, 0, movetoworkspace, 10"

    "${mainMod} CTRL, j, workspace, r+1"
    "${mainMod} CTRL, k, workspace, r-1"
    "${mainMod} CTRL, up, workspace, r-1"
    "${mainMod} CTRL, down, workspace, r+1"

    # Resize windows
    "${mainMod} CONTROL ALT, l, resizeactive, 20 0"
    "${mainMod} CONTROL ALT, h, resizeactive, -20 0"
    "${mainMod} CONTROL ALT, k, resizeactive, 0 -20"
    "${mainMod} CONTROL ALT, j, resizeactive, 0 20"
    "${mainMod} CONTROL ALT, right, resizeactive, 20 0"
    "${mainMod} CONTROL ALT, left, resizeactive, -20 0"
    "${mainMod} CONTROL ALT, up, resizeactive, 0 -20"
    "${mainMod} CONTROL ALT, down, resizeactive, 0 20"

    # Move active window
    "${mainMod} SHIFT, h, movewindoworgroup, l"
    "${mainMod} SHIFT, l, movewindoworgroup, r"
    # "${mainMod} SHIFT, k, movewindoworgroup, u"
    # "${mainMod} SHIFT, j, movewindoworgroup, d"

    # Special workspaces (scratchpad)
    "${mainMod} ALT, S, movetoworkspacesilent, special"
    # "${mainMod}, S, togglespecialworkspace"
    # "${mainMod}, SHIFT, W, movetoworkspace, special"

    # Toggle Layout
    "${mainMod}, o, togglesplit,"

    # "${mainMod} SHIFT, h, movetoworkspace, left"
    # "${mainMod} SHIFT, j, movetoworkspace, up"
    "${mainMod} SHIFT, j, movetoworkspace, +1"
    "${mainMod} SHIFT, k, movetoworkspace, -1"
    "${mainMod} SHIFT, down, movetoworkspace, +1"
    "${mainMod} SHIFT, up, movetoworkspace, -1"
    # Move window silently to workspace Super + Alt + [0-9]
    "${mainMod} ALT, 1, movetoworkspacesilent, 1"
    "${mainMod} ALT, 2, movetoworkspacesilent, 2"
    "${mainMod} ALT, 3, movetoworkspacesilent, 3"
    "${mainMod} ALT, 4, movetoworkspacesilent, 4"
    "${mainMod} ALT, 5, movetoworkspacesilent, 5"
    "${mainMod} ALT, 6, movetoworkspacesilent, 6"
    "${mainMod} ALT, 7, movetoworkspacesilent, 7"
    "${mainMod} ALT, 8, movetoworkspacesilent, 8"
    "${mainMod} ALT, 9, movetoworkspacesilent, 9"
    "${mainMod} ALT, 0, movetoworkspacesilent, 10"

    # Lid switch
    ", switch:on:Lid Switch, exec, swaylock && systemctl suspend"

    "${mainMod} CTRL, w, movetoworkspace, special"
  ];
}
