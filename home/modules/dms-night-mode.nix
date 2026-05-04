{ pkgs, lib, inputs, ... }: {
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];
  programs.dank-material-shell.enable = lib.mkDefault true;
  # Initial check at login — enable night mode if between 20:00 and 07:00
  systemd.user.services.dms-night-initial = {
    Unit = {
      Description = "Set DMS night mode based on current time";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "dms-night-initial" ''
        hour=$(date +%H)
        if (( hour >= 20 || hour < 7 )); then
          dms ipc call night enable
          dms ipc call night temperature 3000
        else
          dms ipc call night disable
        fi
      '';
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Turn ON at 20:00
  systemd.user.services.dms-night-on = {
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "dms-night-on" ''
        dms ipc call night enable
        dms ipc call night temperature 3000
      '';
    };
  };
  systemd.user.timers.dms-night-on = {
    Unit.Description = "Enable DMS night mode at 20:00";
    Timer = {
      OnCalendar = "20:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # Turn OFF at 07:00
  systemd.user.services.dms-night-off = {
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "dms-night-off" ''
        dms ipc call night disable
      '';
    };
  };
  systemd.user.timers.dms-night-off = {
    Unit.Description = "Disable DMS night mode at 07:00";
    Timer = {
      OnCalendar = "07:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
