{
  config,
  pkgs,
  ...
}: {
  # Initial check at login
  systemd.user.services.hyprsunset-initial = {
    Unit = {
      Description = "Set hyprsunset state based on current time";
      After = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c ''
        hour=$(date +%H)
        if (( hour >= 20 || hour < 7 )); then
          hyprsunset -t 3700
        else
          hyprsunset -d
        fi
      ''";
    };
    Install.WantedBy = ["default.target"];
  };

  # Service + timer to turn ON at 20:00
  systemd.user.services.hyprsunset-on = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'hyprsunset -t 3700'";
    };
  };
  systemd.user.timers.hyprsunset-on = {
    Unit.Description = "Enable hyprsunset at 20:00";
    Timer = {
      OnCalendar = "20:00";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };

  # Service + timer to turn OFF at 07:00
  systemd.user.services.hyprsunset-off = {
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'hyprsunset -d'";
    };
  };
  systemd.user.timers.hyprsunset-off = {
    Unit.Description = "Disable hyprsunset at 07:00";
    Timer = {
      OnCalendar = "07:00";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
}
