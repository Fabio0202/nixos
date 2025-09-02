{
  wayland.windowManager.hyprland = {
    settings = {
      animations = {
        enabled = true;

        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];

        animation = [
          # Windows animations
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"

          # Fade animations
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
          "workspaces, 1, 5, default, slidevert"
        ];
      };

      # Define other settings here as needed
      general = {
        "$mainMod" = "SUPER";
        layout = "dwindle";
        gaps_in = 4;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(cba6f7) rgb(94e2d5) 45deg";

        # rose pine colors
        # "col.active_border" = "rgb(eb6f92) rgb(9ccfd8) 45deg";
        "col.inactive_border" = "0x00000000";
        no_border_on_floating = false;
      };

      # Other settings (input, exec-once, misc, decoration, etc.) should follow the same format
      # using lists and attributes as per your working configuration
    };

    extraConfig = ''
      monitor=,preferred,auto,auto

      xwayland {
        force_zero_scaling = true;
      }
    '';
  };
}
