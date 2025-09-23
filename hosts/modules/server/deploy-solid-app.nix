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
  options.myApp.enable = lib.mkEnableOption "Deploy my React + Hono app";

  config = lib.mkIf config.myApp.enable {
    #### Enable Podman
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    #### MongoDB container (via Podman backend)
    virtualisation.oci-containers = {
      backend = "podman";
      containers.mongodb = {
        image = "docker.io/library/mongo:7";
        autoStart = true;
        ports = ["27017:27017"];
        volumes = [
          "/var/lib/mongodb:/data/db"
        ];
      };
    };

    #### Ensure dirs exist
    systemd.tmpfiles.rules = [
      "d ${appRoot} 0755 root root -"
      "d ${backendDir} 0755 root root -"
      "d /var/lib/mongodb 0755 root root -"
    ];

    #### Backend (Hono/Deno) service
    systemd.services.hono-backend = {
      description = "Hono (Deno) Backend";
      after = ["network.target" "oci-containers-mongodb.service"];
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
        User = "simon";
      };
    };

    #### Caddy vhost
    services.caddy = {
      enable = true;
      virtualHosts."${appDomain}".extraConfig = ''
        root * ${appRoot}
        file_server
        reverse_proxy /api/* localhost:8000
      '';
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
