{pkgs, ...}: let
  mainMod = "Super"; # Define Super as the main mod key
in {
  wayland.windowManager.hyprland.settings.bindel = [
    # Audio
    ", F2, exec, swayosd-client --output-volume lower" ## Audio | Lower system volume
    ", F3, exec, swayosd-client --output-volume raise" ## Audio | Raise system volume
    ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
    ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"

    # System (brightness fits best here)
    ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
    ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
  ];

  wayland.windowManager.hyprland.settings.bindm = [
    # Move window with Super + left mouse button
    "${mainMod}, mouse:272, movewindow"

    # Resize window with Super + right mouse button
    "${mainMod}, mouse:273, resizewindow"
  ];
  wayland.windowManager.hyprland.settings.bind = [
    # Workspace
    "${mainMod}, mouse_down, workspace, e+1" ## Workspace | Switch to next workspace
    "${mainMod}, mouse_up, workspace, e-1" ## Workspace | Switch to previous workspace
    "${mainMod}, D, exec, hyprctl dispatch hyprexpo:expo toggle" ## Workspace | Toggle expo view
    "${mainMod}, 1, workspace, 1" ## Workspace | Switch to workspace 1
    "${mainMod}, 2, workspace, 2" ## Workspace | Switch to workspace 2
    "${mainMod}, 3, workspace, 3"
    "${mainMod}, 4, workspace, 4"
    "${mainMod}, 5, workspace, 5"
    "${mainMod}, 6, workspace, 6"
    "${mainMod}, 7, workspace, 7"
    "${mainMod}, 8, workspace, 8"
    "${mainMod}, 9, workspace, 9" ## Workspace | Switch to workspace 9
    "${mainMod}, 0, workspace, 10"
    "${mainMod} Shift, 1, movetoworkspace, 1" ## Workspace | Move focused window to workspace 1
    "${mainMod} Shift, 2, movetoworkspace, 2" ## Workspace | Move focused window to workspace 2
    "${mainMod} Shift, 3, movetoworkspace, 3"
    "${mainMod} Shift, 4, movetoworkspace, 4"
    "${mainMod} Shift, 5, movetoworkspace, 5"
    "${mainMod} Shift, 6, movetoworkspace, 6"
    "${mainMod} Shift, 7, movetoworkspace, 7"
    "${mainMod} Shift, 8, movetoworkspace, 8"
    "${mainMod} Shift, 9, movetoworkspace, 9"
    "${mainMod} Shift, 0, movetoworkspace, 10" ## Workspace | Move focused window to workspace 10
    "${mainMod} CTRL, j, workspace, r+1" ## Workspace | Move to next relative workspace
    "${mainMod} CTRL, k, workspace, r-1" ## Workspace | Move to previous relative workspace
    "${mainMod} CTRL, up, workspace, r-1" ## Workspace | Move to previous relative workspace (arrow)
    "${mainMod} CTRL, down, workspace, r+1" ## Workspace | Move to next relative workspace (arrow)
    "${mainMod} ALT, S, movetoworkspacesilent, special" ## Workspace | Move window silently to special workspace
    "${mainMod} CTRL, w, movetoworkspace, special" ## Workspace | Move to special workspace
    "${mainMod}, Y, togglespecialworkspace, minimized" ## Workspace | Toggle minimized special workspace
    "${mainMod} SHIFT, j, movetoworkspace, +1" ## Workspace | Move window to next workspace
    "${mainMod} SHIFT, k, movetoworkspace, -1" ## Workspace | Move window to previous workspace
    "${mainMod} SHIFT, down, movetoworkspace, +1" ## Workspace | Move window to next workspace (arrow)
    "${mainMod} SHIFT, up, movetoworkspace, -1" ## Workspace | Move window to previous workspace (arrow)
    "${mainMod} ALT, 1, movetoworkspacesilent, 1" ## Workspace | Move window silently to workspace 1
    "${mainMod} ALT, 2, movetoworkspacesilent, 2" ## Workspace | Move window silently to workspace 2
    "${mainMod} ALT, 3, movetoworkspacesilent, 3"
    "${mainMod} ALT, 4, movetoworkspacesilent, 4"
    "${mainMod} ALT, 5, movetoworkspacesilent, 5"
    "${mainMod} ALT, 6, movetoworkspacesilent, 6"
    "${mainMod} ALT, 7, movetoworkspacesilent, 7"
    "${mainMod} ALT, 8, movetoworkspacesilent, 8"
    "${mainMod} ALT, 9, movetoworkspacesilent, 9"
    "${mainMod} ALT, 0, movetoworkspacesilent, 10" ## Workspace | Move window silently to workspace 10

    "${mainMod}, SPACE, exec, show-binds" ## System | Show Keybinds cheat sheet
    # Window
    "${mainMod}, TAB, exec, restore" ## Window | Restore minimized window
    "${mainMod}, N, exec, minimize" ## Window | Minimize focused window
    "${mainMod}, O, exec, ~/nixos/home/scripts/smart-swap.sh" ## Window | Swap window positions
    "${mainMod}, Q, exec, hyprctl dispatch killactive" ## Window | Close focused window
    "${mainMod}, G, togglefloating" ## Window | Toggle floating mode
    "${mainMod}, M, fullscreen" ## Window | Toggle fullscreen
    "ALT, return, fullscreen" ## Window | Toggle fullscreen (Alt+Enter)
    "${mainMod}, H, movefocus, l" ## Window | Move focus left
    "${mainMod}, K, movefocus, u" ## Window | Move focus up
    "${mainMod}, J, movefocus, d" ## Window | Move focus down
    "${mainMod}, L, movefocus, r" ## Window | Move focus right
    "${mainMod}, left, movefocus, l" ## Window | Move focus left (arrow)
    "${mainMod}, up, movefocus, u" ## Window | Move focus up (arrow)
    "${mainMod}, down, movefocus, d" ## Window | Move focus down (arrow)
    "${mainMod}, right, movefocus, r" ## Window | Move focus right (arrow)
    "ALT, Tab, movefocus, d" ## Window | Cycle focus down
    "${mainMod} CONTROL ALT, l, resizeactive, 20 0" ## Window | Resize active window wider
    "${mainMod} CONTROL ALT, h, resizeactive, -20 0" ## Window | Resize active window narrower
    "${mainMod} CONTROL ALT, k, resizeactive, 0 -20" ## Window | Resize active window shorter
    "${mainMod} CONTROL ALT, j, resizeactive, 0 20" ## Window | Resize active window taller
    "${mainMod} CONTROL ALT, right, resizeactive, 20 0" ## Window | Resize active window wider (arrow)
    "${mainMod} CONTROL ALT, left, resizeactive, -20 0" ## Window | Resize active window narrower (arrow)
    "${mainMod} CONTROL ALT, up, resizeactive, 0 -20" ## Window | Resize active window shorter (arrow)
    "${mainMod} CONTROL ALT, down, resizeactive, 0 20" ## Window | Resize active window taller (arrow)
    "${mainMod} SHIFT, h, movewindoworgroup, l" ## Window | Move window/group left
    "${mainMod} SHIFT, l, movewindoworgroup, r" ## Window | Move window/group right
    "${mainMod}, o, togglesplit," ## Window | Toggle split orientation

    # System
    "${mainMod}, P, exec, wlogout --buttons-per-row 5" ## System | Open logout menu
    "${mainMod}, S, exec, hyprctl switchxkblayout current next; pkill -RTMIN+8 waybar" ## System | Switch keyboard layout
    "${mainMod}, delete, exit" ## System | Exit Hyprland
    "${mainMod}, W, exec, waypaper" ## System | Open wallpaper switcher
    "${mainMod}, return, exec, wofi-toggle" ## System | Toggle Wofi
    "${mainMod}, P, exec, pin" ## System | Pin screenshot
    "${mainMod} SHIFT, S, exec, sh -c 'grim -g \"$(slurp)\" - | wl-copy'" ## System | Area screenshot to clipboard
    ", Print, exec, sh -c 'grim - | wl-copy && notify-send \"Screenshot\" \"Copied entire screen to clipboard\"'" ## System | Full screenshot to clipboard
    ", switch:on:Lid Switch, exec, swaylock && systemctl suspend" ## System | Lock & suspend on lid close

    # Audio
    ", F1, exec, swayosd-client --output-volume mute-toggle" ## Audio | Toggle audio mute
    ", F4, exec, swayosd-client --input-volume mute-toggle; pkill -RTMIN+9 waybar" ## Audio | Toggle mic mute
    ", 190, exec, swayosd-client --input-volume mute-toggle; pkill -RTMIN+9 waybar"
    ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
    ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle && toggle-mic-mute-led; pkill -RTMIN+9 waybar"

    # Apps
    "${mainMod}, T, exec, kitty" ## Apps | Launch Kitty terminal
    "${mainMod}, F, exec, nautilus" ## Apps | Launch Nautilus file manager
    "${mainMod}, B, exec, firefox" ## Apps | Launch Firefox
    "${mainMod}, C, exec, code" ## Apps | Launch VS Code
    "${mainMod}, V, exec, kitty nvim" ## Apps | Launch Neovim in Kitty
  ];
}
