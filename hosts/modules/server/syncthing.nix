{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.services.syncthing = {
    after = ["mnt-drive.mount"];
    requires = ["mnt-drive.mount"];
    bindsTo = ["mnt-drive.mount"];
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = false;
    dataDir = "/mnt/drive";
    configDir = "/mnt/drive/syncthing-config";
    user = "simon";

    # GUI only available locally
    settings.gui.address = "127.0.0.1:8384";

    # Hardening: rely only on Tailscale, disable WAN/LAN discovery
    settings.options = {
      natEnabled = false;
      globalAnnounceEnabled = false;
      localAnnounceEnabled = false;
      relayEnabled = false;
    };

    declarative = {
      overrideDevices = false;
      overrideFolders = false;

      # Example devices (uncomment + replace IDs to use):
      # devices = {
      #   laptop-simon.id = "XXXX-XXXX-...";
      #   laptop-fabio.id = "YYYY-YYYY-...";
      # };

      # Example folders (uncomment + adjust paths/devices to use):
      # folders = {
      #   documents = {
      #     path = "/mnt/drive/syncthing/documents";
      #     devices = [ "laptop-simon" "laptop-fabio" ];
      #     versioning = {
      #       type = "simple";
      #       params.keep = "5";
      #     };
      #   };
      # };
    };
  };
}
