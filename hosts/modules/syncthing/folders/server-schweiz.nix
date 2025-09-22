{config, ...}: {
  services.syncthing.folders = {
    "documents-simon" = {
      # this is the folder ID (shared across devices)
      path = "/mnt/drive/syncthing/simon/Documents"; # local path on this machine
      devices = ["simon-pc" "simon-laptop" "server-schweiz"];
      versioning = {type = "trashcan";};
    };

    "task-simon" = {
      # another folder ID
      path = "/mnt/drive/syncthing/simon/.task";
      devices = ["simon-pc" "simon-laptop" "server-schweiz"];
      versioning = {type = "trashcan";};
    };
  };
}
