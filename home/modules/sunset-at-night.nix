{ config
, pkgs
, ...
}: {
  # Initial check at login
  systemd.user.services.hyprsunset-initial = {
    Unit = {
      Description = "Set hyprsunset state based on current time";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "hyprsunset-initial" ''
        hour=$(date +%H)
        if (( hour >= 20 || hour < 7 )); then
          hyprsunset -t 3000
        else
          hyprsunset -d
        fi
      '';
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Service + timer to turn ON at 20:00
  systemd.user.services.hyprsunset-on = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 3000";
    };
  };
  systemd.user.timers.hyprsunset-on = {
    Unit.Description = "Enable hyprsunset at 20:00";
    Timer = {
      OnCalendar = "20:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # Service + timer to turn OFF at 07:00
  systemd.user.services.hyprsunset-off = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -d";
    };
  };
  systemd.user.timers.hyprsunset-off = {
    Unit.Description = "Disable hyprsunset at 07:00";
    Timer = {
      OnCalendar = "07:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
