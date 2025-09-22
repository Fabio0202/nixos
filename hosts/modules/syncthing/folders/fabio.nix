{config, ...}: {
  services.syncthing.folders = {
    "documents-fabio" = {
      # this is the folder ID (shared across devices)
      path = "/home/fabio/Documents"; # local path on this machine
      devices = ["fabio-laptop-lenovo" "fabio-pc" "server-schweiz"];
      versioning = {type = "trashcan";};
    };

    "task-fabio" = {
      # another folder ID
      path = "/home/fabio/.task";
      devices = ["fabio-laptop-lenovo" "fabio-pc" "server-schweiz"];
      versioning = {type = "trashcan";};
    };
  };
}
