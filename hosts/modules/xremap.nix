{ config, pkgs, pkgs-unstable, ... }:
let
  xremap-hypr = pkgs-unstable.xremap.override { withVariant = "hyprland"; };
in
{
  users.users.simon.extraGroups = [ "input" ];

  hardware.uinput.enable = true;

  systemd.user.services.xremap = {
    description = "xremap key remapper";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${xremap-hypr}/bin/xremap /home/simon/.config/xremap/config.yml";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };

  systemd.user.services.xremap-environment = {
    description = "Import Hyprland environment for xremap";
    after = [ "graphical-session.target" ];
    before = [ "xremap.service" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE XDG_RUNTIME_DIR";
      RemainAfterExit = true;
    };
  };
}