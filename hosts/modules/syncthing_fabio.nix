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
          id = "MMRJWPX-7YX3TQW-OCVPOQL-2IP22QH-SJLAXIE-A3AGC7C-3546S6L-ZVQGUQP";
          name = "fabio-pc";
        };
        server-schweiz = {
          id = "UOEO2XJ-BUWG4DZ-EXVJ7MZ-RPIYOB7-KAOZQZN-55SIJYW-OD4CYTG-Q36FKQF";
          name = "server-schweiz";
        };

        fabio-laptop-lenovo = {
          id = "4ZLQ5YQ-LHX6M7G-MQHQEOL-QWLZSFQ-KOIYB5F-NDPYLWB-PLCJEGF-CDT6PAI";
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
