{...}: {
  services.syncthing = {
    enable = true;
    user = "fabio"; # run Syncthing as your user
    dataDir = "/home/fabio/.config/syncthing";

    settings = {
      devices = {
        "desktop" = {
          id = "O7H5UW2-DIDLB5Y-2MBGZZI-LRFHQBT-XYSRP2L-QW4X2VD-BVEERQG-OI52HQZ";
          name = "simon-laptop";
          introducer = true;
        };

        "server-salzburg" = {
          id = "IL3DCZS-4ASMHNV-UJ654ZK-BEL5LFU-5AVY764-BHTRCVL-THGBZPH-ZIAKVAJ";
          name = "server-salzburg";
        };
        "server-schweiz" = {
          id = "UOEO2XJ-BUWG4DZ-EXVJ7MZ-RPIYOB7-KAOZQZN-55SIJYW-OD4CYTG-Q36FKQF";
          name = "server-schweiz";
        };
      };

      folders = {
        "shared-docs" = {
          id = "shared-docs"; # must match the desktop's folder ID
          path = "/home/fabio/Sync/"; # local folder path on the laptop
          devices = ["desktop"]; # sync with your desktop
          type = "sendreceive";
        };
      };
    };
  };
}
