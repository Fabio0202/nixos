{pkgs, ...}: {
  home.packages = with pkgs; [
    hypridle
  ];

  home.file.".config/hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
    }

    # lock after 15 minutes
    listener {
        timeout = 900
        on-timeout = bash -c '[ ! -f /tmp/disable-idle ] && loginctl lock-session'
    }

    # turn off display ~20s after lock
    listener {
        timeout = 920
        on-timeout = bash -c '[ ! -f /tmp/disable-idle ] && hyprctl dispatch dpms off'
        on-resume = hyprctl dispatch dpms on
    }

    # suspend after 30 minutes
    listener {
        timeout = 1800
        on-timeout = bash -c '[ ! -f /tmp/disable-idle ] && systemctl suspend'
    }
  '';
}
