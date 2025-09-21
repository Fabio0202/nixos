{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  # Configurable parameters
  siteName = "simone-muscas-site";
  domain = "simone-muscas.com";
  port = 3000;
  user = "simon";
in {
  # Cloudflare tunnel configuration remains unchanged
  services.cloudflared.enable = true;
  services.cloudflared.tunnels.${siteName} = {
    credentialsFile = "/etc/cloudflared/simone-tunnel.json";
    ingress."${domain}" = "http://localhost:3000";
    default = "http_status:404";
  };
}
