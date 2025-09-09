{
  config,
  pkgs,
  ...
}: {
  systemd.user.services.battery-monitor = {
    Unit = {
      Description = "Battery monitor with notifications and sounds";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "%h/nixos/home/scripts/battery-monitor.sh";
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = ["default.target"];
  };
}
