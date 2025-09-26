{
  config,
  lib,
  pkgs,
  ...
}: let
  appDomain = "app.simone-muscas.com";
in {
  options.myApp.enable = lib.mkEnableOption "Deploy my React + Hono app";

  config = lib.mkIf config.myApp.enable {
    systemd.services.app-stack = {
      description = "App stack (frontend, backend, mongo)";
      after = ["docker.service" "network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        WorkingDirectory = "/home/simon/code/solid-deno";
        ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f docker-compose.prod.yml up";
        ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f docker-compose.prod.yml down";
        Restart = "always";
        User = "simon";
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts."${appDomain}".extraConfig = ''
        reverse_proxy /api/* localhost:8000
        reverse_proxy /* localhost:3000
      '';
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
