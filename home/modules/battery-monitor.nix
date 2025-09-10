{
  config,
  pkgs,
  ...
}: {
  systemd.user.services.battery-monitor = {
    Unit = {
      Description = "Battery monitor with notifications and sounds";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${config.home.homeDirectory}/nixos/home/scripts/battery-monitor.sh";
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
