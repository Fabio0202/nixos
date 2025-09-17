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
    openDefaultPorts = true;
    dataDir = "/mnt/drive";
    configDir = "/mnt/drive/syncthing-config";
    user = "fabio";

    guiAddress = "127.0.0.1:8384"; # safer, tunnel if needed

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
        };
        fabio-laptop-lenovo = {
          id = "4ZLQ5YQ-LHX6M7G-MQHQEOL-QWLZSFQ-KOIYB5F-NDPYLWB-PLCJEGF-CDT6PAI";
        };
        server-salzburg = {
          id = "IL3DCZS-4ASMHNV-UJ654ZK-BEL5LFU-5AVY764-BHTRCVL-THGBZPH-ZIAKVAJ";
        };
      };

      folders = {
        documents = {
          path = "/mnt/drive/syncthing/fabio/documents";
          devices = ["fabio-laptop-lenovo" "fabio-pc" "server-salzburg"];
          versioning = {type = "trashcan";};
        };
      };
    };
  };
}
