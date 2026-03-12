{ config
, lib
, pkgs
, ...
}:
let
  domain = "simone-muscas.com";
in
{
  # Cloudflared tunnel
  services.cloudflared.enable = true;

  services.cloudflared.tunnels."simone-tunnel" = {
    credentialsFile = "/etc/cloudflared/simone-tunnel.json";

    ingress = {
      # Personal - Only me (PIN protected via Cloudflare Access)
      "notes.${domain}" = "http://localhost:8003";      # Silverbullet
      "kuma.${domain}" = "http://localhost:3001";       # Uptime monitoring
      "homarr.${domain}" = "http://localhost:7575";     # Dashboard
      "paperless.${domain}" = "http://localhost:8010";  # Documents
      # Baserow NOT exposed to internet (database - too sensitive)

      # Friends - Shared access (PIN or approval)
      "jellyfin.${domain}" = "http://localhost:8096";   # Media server
      "overseerr.${domain}" = "http://localhost:12345";  # Media requests
      "filebrowser.${domain}" = "http://localhost:8080"; # File sharing
      "share.${domain}" = "http://localhost:8081";      # File sharing (alt)

      # Route app through Caddy
      "app.${domain}" = "http://localhost:80";
    };

    default = "http_status:404";
  };

  # No need to expose ports 80/443 to the internet anymore
  networking.firewall.allowedTCPPorts = [ ];
}
