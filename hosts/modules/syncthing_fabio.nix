{
  config,
  lib,
  pkgs,
  ...
}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    configDir = "/home/fabio/.config/syncthing-config";
    user = "fabio";

    guiAddress = "0.0.0.0:8384"; # safer, tunnel if needed

    settings.options = {
      natEnabled = false;
      globalAnnounceEnabled = true;
      localAnnounceEnabled = true;
      relayEnabled = false;
    };

    declarative = {
      overrideDevices = true;
      overrideFolders = true;

      devices = {
        fabio-pc = {
          id = "YNYJV2K-UTS3MTJ-RTVBJ44-EZAC7QB-2GI3Y3P-VIKKUVO-N4OLOUF-5AEHJQO";
          name = "fabio-pc";
        };
        server-schweiz = {
          id = "UOEO2XJ-BUWG4DZ-EXVJ7MZ-RPIYOB7-KAOZQZN-55SIJYW-OD4CYTG-Q36FKQF";
          name = "server-schweiz";
        };

        fabio-laptop-lenovo = {
          id = "G6JHDK7-K7AB5YJ-JXUGO7K-QH4OEVF-IGB7Q6R-2WCTX2D-IBYV4I2-MBZXNQA";
          name = "fabio-laptop-lenovo";
        };
        server-salzburg = {
          id = "IL3DCZS-4ASMHNV-UJ654ZK-BEL5LFU-5AVY764-BHTRCVL-THGBZPH-ZIAKVAJ";
          name = "server-salzburg";
        };
      };

      folders = {
        "fabio-documents" = {
          path = "/home/fabio/Documents";
          devices = ["fabio-laptop-lenovo" "fabio-pc" "server-salzburg" "server-schweiz"];
          versioning = {type = "trashcan";};
        };
      };
    };
  };
}
