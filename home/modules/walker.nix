{ pkgs, pkgs-unstable, ... }: {
  # Elephant — backend daemon for walker launcher
  systemd.user.services.elephant = {
    Unit = {
      Description = "Elephant backend for walker launcher";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.elephant}/bin/elephant";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Walker GApplication service — keeps walker warm in memory for near-instant launch
  systemd.user.services.walker = {
    Unit = {
      Description = "Walker launcher GApplication service";
      After = [ "graphical-session.target" ];
      BindsTo = [ "elephant.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs-unstable.walker}/bin/walker --gapplication-service";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
