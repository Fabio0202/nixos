{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    plugin.hyprexpo = {
      enable_gesture = false; # prevent Hyprexpo from hijacking swipes
    };

    gesture = [
      # 4-finger vertical swipe → workspace switching
      "4, vertical, scale:0.8, workspace"

      # 4-finger horizontal swipes → Hyprexpo toggle
      "4, right, dispatcher, hyprexpo:expo, toggle"
      "4, left,  special, minimized"

      # 3-finger focus navigation (no mods)
      "3, left,  dispatcher, movefocus, l"
      "3, right, dispatcher, movefocus, r"
      "3, up,    dispatcher, movefocus, u"
      "3, down,  dispatcher, movefocus, d"

      # Super + 3 fingers → resize
      "3, left,  mod:SUPER, resize"
      "3, right, mod:SUPER, resize"
      "3, up,    mod:SUPER, resize"
      "3, down,  mod:SUPER, resize"

      # Shift + 3 fingers
      # horizontal → move active window
      "3, left,  mod:SHIFT, move"
      "3, right, mod:SHIFT, move"

      # vertical → move whole workspace
      "3, up,    mod:SHIFT, dispatcher, movetoworkspace, r+1"
      "3, down,  mod:SHIFT, dispatcher, movetoworkspace, r-1"
    ];
  };
}
