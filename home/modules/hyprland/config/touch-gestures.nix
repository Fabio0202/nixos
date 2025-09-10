{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    gestures = {
      workspace_swipe = false; # disable built-in 3-finger default
    };

    # Four-finger swipe for workspace switching
    gesture = [
      "4, right, workspace, r+1"
      "4, left, workspace, r-1"
      " gesture = 3, right, focuswindow, r+1"
      "gesture = 3, left, focuswindow, r-1"
    ];

    # Three-finger swipe for focusing windows
  };
}
