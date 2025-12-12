{ ... }:
let
  defaultVersioning = {
    type = "simple";
    params.keep = "5";
  };
in
{
  services.syncthing.folders = {
    "documents-fabio" = {
      path = "/mnt/drive/syncthing/fabio/Documents";
      devices = [
        "fabio-laptop-windows"
        "server-wien"
        "fabio-laptop-hp"
        "fabio-pc"
        "server-schweiz"
      ];
      versioning = defaultVersioning;
    };

    "shared" = {
      # this is the folder ID (shared across devices)
      path = "/mnt/drive/shared/"; # local path on this machine
      devices = [ "simon-pc" "simon-laptop" "server-schweiz" "server-wien" "fabio-laptop-hp" "fabio-pc" ];
      versioning = { type = "trashcan"; };
    };
    "task-fabio" = {
      path = "/mnt/drive/syncthing/fabio/.task";
      devices = [
        "server-wien"
        "fabio-pc"
        "fabio-laptop-hp"
        "server-schweiz"
      ];
      versioning = defaultVersioning;
    };

    "documents-simon" = {
      path = "/mnt/drive/syncthing/simon/Documents";
      devices = [
        "server-wien"
        "simon-pc"
        "simon-laptop"
        "server-schweiz"
      ];
      versioning = defaultVersioning;
    };

    "task-simon" = {
      path = "/mnt/drive/syncthing/simon/.task";
      devices = [
        "server-wien"
        "simon-pc"
        "simon-laptop"
        "server-schweiz"
      ];
      versioning = defaultVersioning;
    };

    "cloud" = {
      path = "/mnt/drive/cloud";
      devices = [ "server-wien" "server-schweiz" ];
      versioning = defaultVersioning;
    };
  };
}
