{...}: let
  defaultVersioning = {
    type = "simple";
    params.keep = "5";
  };
in {
  services.syncthing.folders = {
    "documents-fabio" = {
      path = "/mnt/drive/syncthing/fabio/Documents";
      devices = [
        "server-wien"
        "fabio-laptop-lenovo"
        "fabio-laptop-hp"
        "fabio-pc"
        "server-schweiz"
      ];
      versioning = defaultVersioning;
    };

    "task-fabio" = {
      path = "/mnt/drive/syncthing/fabio/.task";
      devices = [
        "server-wien"
        "fabio-laptop-lenovo"
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
      devices = ["server-wien" "server-schweiz"];
      versioning = defaultVersioning;
    };
  };
}
