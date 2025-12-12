{ lib, ... }:
let
  # Generic proxy
  # NOTE: currently unused because I am using cloudlflared tunnel instead
  # which does reverse proxying itself and is safer (no need to open ports)
  mkProxy = port: ''
    reverse_proxy localhost:${toString port}
  '';

  # Special case for Jellyfin (needs forwarded headers)
  jellyfinProxy = ''
    reverse_proxy localhost:8096 {
      header_up X-Real-IP {remote_host}
      header_up X-Forwarded-For {remote_host}
      header_up X-Forwarded-Proto {scheme}
    }
  '';
in
{
  services.nginx.enable = false;

  services.caddy = {
    enable = true;

    virtualHosts = {
      "jellyfin.simone-muscas.com".extraConfig = jellyfinProxy;
      "radarr.simone-muscas.com".extraConfig = mkProxy 7878;
      "sonarr.simone-muscas.com".extraConfig = mkProxy 8989;
      "bazarr.simone-muscas.com".extraConfig = mkProxy 6768;
      "prowlarr.simone-muscas.com".extraConfig = mkProxy 9696;
      "deluge.simone-muscas.com".extraConfig = mkProxy 8112;
      "overseerr.simone-muscas.com".extraConfig = mkProxy 12345;
      "app.simone-muscas.com".extraConfig = ''
        root * /var/www/react-app/dist
        file_server
        reverse_proxy /api/* localhost:8000
      '';
      "plex.simone-muscas.com".extraConfig = jellyfinProxy;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
