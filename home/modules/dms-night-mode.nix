{ pkgs, pkgs-unstable, ... }: {
  # hyprsunset uses hyprland-ctm-control-v1 which works on AMD GPUs
  # (DMS uses wlr-gamma-control which requires hardware gamma LUT - not available on Renoir)
  systemd.user.services.hyprsunset = {
    Unit = {
      Description = "Blue light filter via hyprsunset (CTM-based)";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "hyprsunset-start" ''
        hour=$(date +%H)
        if (( hour >= 20 || hour < 7 )); then
          temp=3000
        else
          temp=6500
        fi
        exec ${pkgs-unstable.hyprsunset}/bin/hyprsunset -t "$temp"
      '';
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Switch to night temperature at 20:00
  systemd.user.services.hyprsunset-night = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.procps}/bin/pkill -x hyprsunset || true";
    };
  };
  systemd.user.timers.hyprsunset-night = {
    Unit.Description = "Switch hyprsunset to night temperature";
    Timer = {
      OnCalendar = "20:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # Switch to day temperature at 07:00
  systemd.user.services.hyprsunset-day = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.procps}/bin/pkill -x hyprsunset || true";
    };
  };
  systemd.user.timers.hyprsunset-day = {
    Unit.Description = "Switch hyprsunset to day temperature";
    Timer = {
      OnCalendar = "07:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
