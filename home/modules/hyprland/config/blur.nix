{
  wayland.windowManager.hyprland.settings.decoration = {
    rounding = 8; # Slightly increased for smoother, rounded corners
    # shadow = {
    #   enabled = true;
    # };
    shadow = {
      enabled = true;
      range = 12;
      # color = "rgba(49, 50, 68, 0.6)"; # surface0 with transparency
    };
    # mac style
    blur = {
      size = 6; # Smaller = smoother, less GPU-heavy
      passes = 2; # Balanced quality/performance
      noise = 0.01; # Minimal noise
      contrast = 1.1; # Slight contrast boost
      brightness = 0.9; # Brighten blurred areas
      vibrancy = 1.0; # Max vibrancy for vivid colors
      popups = false; # Blur context menus/dialogs
    };

    # a bit more intense
    # blur = {
    #   enabled = true;
    #   size = 8; # Slightly smaller for smoother performance
    #   passes = 3; # More passes = higher quality (but heavier)
    #   noise = 0.0117; # Very subtle grain (avoids "plastic" look)
    #   contrast = 1.2; # Enhances sharpness under blur
    #   brightness = 0.8; # Prevents blur from darkening windows too much
    #   vibrancy = 0.9; # Makes colors pop under blur
    #   vibrancy_darkness = 0.05; # Less darkening for vibrant colors
    #   special = true; # Apply blur to floating windows
    #   popups = true; # Blur popups (e.g., rofi, notifications)
    # };
  };
}
