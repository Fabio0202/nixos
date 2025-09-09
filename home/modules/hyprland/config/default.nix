{
  pkgs,
  config,
  pkgs-unstable,
  ...
}: let
  term = "kitty";
  editor = "nvim";
  file = "nautilus";
  browser = "firefox";
in {
  imports = [
    ./keybinds.nix
    ./animations.nix
    ./touch-gestures.nix
    ./windowrules.nix
    ./blur.nix
    ./monitors.nix
    # {inherit term editor file browser;}
  ];

  home.packages = with pkgs; [
    rose-pine-cursor
  ];

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar -c %h/.config/waybar/config.json --log-level=error";
      Restart = "always";
      RestartSec = 2;
      StandardOutput = "append:%h/.cache/waybar.log";
      StandardError = "append:%h/.cache/waybar.log";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
  home.sessionVariables = {
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "rose-pine-cursor";
  };
  wayland.windowManager.hyprland = {
    plugins = [
      # this makes it like paperwm but I dont want it for now
      # pkgs.hyprlandPlugins.hyprscroller

      # this is for touch gestures, gotta try on laptop
      pkgs.hyprlandPlugins.hyprgrass

      # overview of workspaces
      pkgs.hyprlandPlugins.hyprspace

      pkgs.hyprlandPlugins.hypr-dynamic-cursors
    ];

    enable = true;
    settings = {
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      plugin = {
        dynamic-cursors = {
          enable = true;
          mode = "stretch";
        };
      };

      input = import ./input.nix;
      # applications = {
      #   inherit term editor file browser;
      # };
    };
    extraConfig = ''
      monitor=,preferred,auto,auto
      exec-once = nwg-dock-hyprland -nolauncher -d -hd 0
      exec-once = udiskie -a
      exec-once = hypridle
      exec-once = ags
      # exec-once = nwg-panel
      exec-once = ~/nixos/home/scripts/battery-monitor.sh
      xwayland {
        force_zero_scaling = true;
      }


      exec-once = nm-applet --indicator
      # exec-once = ~/nixos/home/scripts/start_waybar.sh
    '';
  };
  systemd.user.services.ax-shell = {};
}
