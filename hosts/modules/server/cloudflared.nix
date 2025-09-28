{
  config,
  lib,
  pkgs,
  ...
}: let
  domain = "simone-muscas.com";
in {
  # Cloudflared tunnel
  services.cloudflared.enable = true;

  services.cloudflared.tunnels."simone-tunnel" = {
    credentialsFile = "/etc/cloudflared/simone-tunnel.json";

    ingress = {
      # Direct → apps (no Caddy needed)
      "jellyfin.${domain}" = "http://localhost:8096";
      "overseerr.${domain}" = "http://localhost:12345";

      # Route app through Caddy
      "app.${domain}" = "http://localhost:3000";

      "default" = "http_status:404";
    };
  };

  # Keep Caddy only for the React app + API
  services.caddy = {
    enable = true;
    virtualHosts."app.${domain}".extraConfig = ''
      root * /var/www/react-app/dist
      file_server
      reverse_proxy /api/* localhost:8000
    '';
  };

  # No need to expose ports 80/443 to the internet anymore
  networking.firewall.allowedTCPPorts = [];
}
