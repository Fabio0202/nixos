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

    listener {
        timeout = 300
        on-timeout = bash -c '[ ! -f /tmp/disable-idle ] && loginctl lock-session'
    }

    listener {
        timeout = 320
        on-timeout = bash -c '[ ! -f /tmp/disable-idle ] && hyprctl dispatch dpms off'
        on-resume = hyprctl dispatch dpms on
    }

    listener {
        timeout = 900
        on-timeout = bash -c '[ ! -f /tmp/disable-idle ] && systemctl suspend'
    }
  '';
}
