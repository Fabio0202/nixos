{...}: {
  services.syncthing.folders = {
    "documents-fabio" = {
      # this is the folder ID (shared across devices)
      path = "/mnt/drive/syncthing/fabio/Documents"; # local path on this machine
      devices = ["server-wien" "fabio-laptop-lenovo" "fabio-laptop-hp" "fabio-pc" "server-schweiz"];
      versioning = {type = "trashcan";};
    };
    "task-fabio" = {
      # another folder ID
      path = "/mnt/drive/syncthing/fabio/.task";
      devices = ["server-wien" "fabio-laptop-lenovo" "fabio-pc" "fabio-laptop-hp" "server-schweiz"];
      versioning = {type = "trashcan";};
    };
    "documents-simon" = {
      # this is the folder ID (shared across devices)
      path = "/mnt/drive/syncthing/simon/Documents"; # local path on this machine
      devices = ["server-wien" "simon-pc" "simon-laptop" "server-schweiz"];
      versioning = {type = "trashcan";};
    };

    "task-simon" = {
      # another folder ID
      path = "/mnt/drive/syncthing/simon/.task";
      devices = ["server-wien" "simon-pc" "simon-laptop" "server-schweiz"];
      versioning = {type = "trashcan";};
    };
  };
}
