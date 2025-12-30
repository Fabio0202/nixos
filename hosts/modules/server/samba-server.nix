{ config, pkgs, ... }:

{
  # Enable Samba server
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = false; # We only want Tailscale access, not public
    
    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "server-wien";
        "netbios name" = "server-wien";
        security = "user";
        
        # Only allow Tailscale network (100.64.0.0/10)
        "hosts allow" = "100.64.0.0/10 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        
        # Allow guest access for simplicity (still secured by Tailscale)
        "map to guest" = "bad user";
        
        # Performance tuning
        "use sendfile" = "yes";
        "max protocol" = "SMB3";
        "min protocol" = "SMB2";
        
        # Logging
        "logging" = "systemd";
      };
      
      # Simon's cloud folder
      "simon-cloud" = {
        path = "/mnt/drive/cloud/simon";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      
      # Fabio's cloud folder
      "fabio-cloud" = {
        path = "/mnt/drive/cloud/fabio";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };
  
  # Enable Samba WSDD for network discovery (optional, mainly for Windows)
  services.samba-wsdd = {
    enable = true;
    openFirewall = false; # Only Tailscale
  };
  
  # Make Samba server depend on drive being mounted
  systemd.services.samba-smbd = {
    after = [ "mnt-drive.mount" ];
    requires = [ "mnt-drive.mount" ];
    partOf = [ "mnt-drive.mount" ];
    bindsTo = [ "mnt-drive.mount" ];
    serviceConfig.Restart = "on-failure";
  };
  
  # Also make nmbd (NetBIOS name service) depend on the mount
  systemd.services.samba-nmbd = {
    after = [ "mnt-drive.mount" ];
    requires = [ "mnt-drive.mount" ];
    partOf = [ "mnt-drive.mount" ];
    bindsTo = [ "mnt-drive.mount" ];
    serviceConfig.Restart = "on-failure";
  };
  
  # Open Samba ports only on Tailscale interface
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [ 
      139  # SMB over NetBIOS
      445  # SMB over TCP
    ];
    allowedUDPPorts = [ 
      137  # NetBIOS Name Service
      138  # NetBIOS Datagram Service
    ];
  };
}
