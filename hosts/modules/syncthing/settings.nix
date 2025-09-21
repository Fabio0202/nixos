# syncthing.nix
{user}: {
  services.syncthing = {
    enable = true;
    inherit user;
    guiAddress = "0.0.0.0:8384";
    dataDir = "/home/${user}/.local/share/syncthing";
    configDir = "/home/${user}/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;

    # Hardening: rely only on Tailscale, disable WAN/LAN discovery
    # settings.options = {
    #   natEnabled = false;          # ❌ Don’t try UPnP/NAT traversal — no poking holes in the router
    #   globalAnnounceEnabled = false; # ❌ Don’t announce this device to Syncthing’s global discovery servers
    #   localAnnounceEnabled = false;  # ❌ Don’t broadcast presence on the local LAN (via multicast)
    #   relayEnabled = false;          # ❌ Don’t use public relay servers for connections
    # };
  };
}
