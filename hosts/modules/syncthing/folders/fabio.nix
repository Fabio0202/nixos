{config, ...}: {
  services.syncthing.folders = {
    "documents-fabio" = {
      # this is the folder ID (shared across devices)
      path = "/home/fabio/Documents"; # local path on this machine
      devices = ["server-wien" "fabio-laptop-lenovo" "fabio-laptop-hp" "fabio-pc" "server-schweiz"];
      versioning = {type = "trashcan";};
    };

    "task-fabio" = {
      # another folder ID
      path = "/home/fabio/.task";
      devices = ["server-wien" "fabio-laptop-lenovo" "fabio-laptop-hp" "fabio-pc" "server-schweiz"];
      versioning = {type = "trashcan";};
    };
  };
}
