{ config
, pkgs
, ...
}: {
  networking.firewall = {
    enable = true;

    # Global ports (accessible from LAN + WAN)
    allowedTCPPorts = [
      80 # HTTP (Plex/Overseerr via reverse proxy)
      443 # HTTPS (Plex/Overseerr via reverse proxy)
    ];

    # Allow everything via Tailscale
    interfaces.tailscale0 = {
      allowedTCPPortRanges = [
        {
          from = 1;
          to = 65535;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1;
          to = 65535;
        }
      ];
    };
  };

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    iw
    wpa_supplicant
    networkmanager
  ];
}
