{
  config,
  lib,
  pkgs,
  ...
}: let
  appDomain = "app.simone-muscas.com";
  appRoot = "/var/www/react-app/dist";
  backendDir = "/var/www/hono-api";
in {
  options.denoApp.enable = lib.mkEnableOption "Deploy my React + Hono app";

  config = lib.mkIf config.denoApp.enable {
    #### Frontend build (just served by Caddy)
    # You rsync/copy `dist/` into ${appRoot}
    systemd.tmpfiles.rules = [
      "d ${appRoot} 0755 root root -" # ensure directory exists
    ];

    #### Backend (Hono/Deno) service
    systemd.services.hono-backend = {
      description = "Hono (Deno) Backend";
      after = ["network.target" "mongodb-container.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        WorkingDirectory = backendDir;
        ExecStart = ''
          ${pkgs.deno}/bin/deno run \
            --allow-net \
            --allow-read \
            --allow-env \
            --allow-sys \
            api/main.ts
        '';
        Restart = "always";
        RestartSec = 5;
        User = "www-data"; # Or another non-root service user
      };
    };

    #### MongoDB container
    services.containers = {
      enable = true;
      containers.mongodb = {
        image = "mongo:7";
        autoStart = true;
        ports = ["27017:27017"];
        volumes = [
          "/var/lib/mongodb:/data/db"
        ];
      };
    };

    #### Caddy vhost
    services.caddy = {
      enable = true;
      virtualHosts = {
        "${appDomain}".extraConfig = ''
          root * ${appRoot}
          file_server
          reverse_proxy /api/* localhost:8000
        '';
      };
    };

    #### Firewall
    networking.firewall.allowedTCPPorts = [80 443];
  };
}
