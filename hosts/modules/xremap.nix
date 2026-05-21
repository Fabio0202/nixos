{ config, pkgs, ... }:
let
  xremap-niri = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "xremap-niri";
    version = pkgs.xremap.version;
    src = pkgs.xremap.src;
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildNoDefaultFeatures = true;
    buildFeatures = [ "niri" ];
    cargoHash = "sha256-ucyBQPCskHwz8rYzOULJ3enL6rhvpLxJzS7sTNwuBW4=";
  });
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
      ExecStart = "${xremap-niri}/bin/xremap /home/simon/.config/xremap/config.yml";
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
