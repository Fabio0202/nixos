{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";

      # timeouts per urgency
      timeout = 6;
      timeout-low = 5;
      timeout-critical = 0;

      widgets = [
        "title"
        "dnd"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };
    };

    style = ''
      /* Catppuccin Mocha palette */
      @define-color base       #1e1e2e;
      @define-color mantle     #181825;
      @define-color crust      #11111b;
      @define-color text       #cdd6f4;
      @define-color subtext0   #a6adc8;
      @define-color subtext1   #bac2de;
      @define-color overlay0   #6c7086;
      @define-color overlay1   #7f849c;
      @define-color overlay2   #9399b2;
      @define-color blue       #89b4fa;
      @define-color lavender   #b4befe;
      @define-color sapphire   #74c7ec;
      @define-color sky        #89dceb;
      @define-color teal       #94e2d5;
      @define-color green      #a6e3a1;
      @define-color yellow     #f9e2af;
      @define-color peach      #fab387;
      @define-color maroon     #eba0ac;
      @define-color red        #f38ba8;
      @define-color mauve      #cba6f7;
      @define-color pink       #f5c2e7;
      @define-color flamingo   #f2cdcd;
      @define-color rosewater  #f5e0dc;
      @define-color surface0   #313244; /* used below */

      /* ---------- DND switch ---------- */
      .widget-dnd switch {
        background-color: @surface0;
        border-radius: 12px;
        min-width: 36px;
        min-height: 18px;
        border: 1px solid @overlay0;
        transition: background-color 150ms ease;
      }
      .widget-dnd switch slider {
        background-color: @subtext1;
        border-radius: 50%;
        min-width: 14px;
        min-height: 14px;
        margin: 2px;
        transition: margin-left 150ms ease;
      }
      .widget-dnd switch:checked {
        background-color: @mauve;
        border-color: @mauve;
      }
      .widget-dnd switch:checked slider {
        background-color: @base;
      }

      /* ---------- Notifications: single-border fix ---------- */

      /* Remove any borders/frames on the OUTER row */
      .notification,
      .control-center .notification,
      .notification-row {
        background: transparent;
        border: none;
        box-shadow: none;
        padding: 0;      /* we pad the inner box instead */
        margin-top: 4px; /* keep spacing between rows */
      }

      /* Style ONLY the inner background box */
      .notification .notification-background,
      .control-center .notification .notification-background {
        background-color: @base;
        border-radius: 12px;
        border: 1px solid @surface0;   /* single, clean border */
        color: @text;
        padding: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.4);
      }

      /* Critical variant: thicker red single border */
      .notification.critical .notification-background {
        border-color: @red;
        border-width: 2px;
        font-weight: bold;
      }

      /* Low urgency: slightly dim inner box */
      .notification.low .notification-background {
        opacity: 0.85;
      }

      /* Widgets & control center */
      .widget {
        background-color: @mantle;
        border-radius: 12px;
        border: 1px solid @surface0;
        color: @text;
        padding: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.4);
      }
      .control-center {
        background-color: @crust;
        border-radius: 16px;
        padding: 12px;
      }

      .notification .close-button {
        margin: 20px;
      }

      .button {
        background-color: @surface0;
        color: @text;
        border-radius: 10px;
        padding: 6px 10px;
        margin: 12px;
      }
      .button:hover {
        background-color: @mauve;
        color: @base;
      }
    '';
  };

  # Script that listens for screen share events
  home.file.".local/bin/swaync-screencast.sh" = {
    text = ''
      #!/usr/bin/env bash
      dbus-monitor --session "interface='org.freedesktop.portal.ScreenCast'" |
        while read -r line; do
          if [[ "$line" == *"method call"* && "$line" == *"Start"* ]]; then
            echo "[ScreenCast] Started → enabling DND"
            swaync-client --dnd-on
          elif [[ "$line" == *"method call"* && "$line" == *"Stop"* ]]; then
            echo "[ScreenCast] Stopped → disabling DND"
            swaync-client --dnd-off
          fi
        done
    '';
    executable = true;
  };

  # Systemd user service to keep it running
  systemd.user.services.swaync-screencast = {
    Unit = {
      Description = "Toggle swaync Do Not Disturb when screen sharing";
      After = ["swaync.service"];
    };
    Service = {
      ExecStart = "%h/.local/bin/swaync-screencast.sh";
      Restart = "always";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}
