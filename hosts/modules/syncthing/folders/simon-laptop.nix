{ config, ... }: {
  services.syncthing.folders = {
    "documents-simon" = {
      # this is the folder ID (shared across devices)
      path = "/home/simon/Documents"; # local path on this machine
      devices = [ "simon-pc" "simon-laptop" "server-schweiz" "server-wien" ];
      versioning = { type = "trashcan"; };
    };

    "shared" = {
      # this is the folder ID (shared across devices)
      path = "/home/simon/shared/"; # local path on this machine
      devices = [ "simon-pc" "simon-laptop" "server-schweiz" "server-wien" "fabio-laptop-hp" "fabio-pc" ];
      versioning = { type = "trashcan"; };
    };
    "task-simon" = {
      # another folder ID
      path = "/home/simon/.task";
      devices = [ "simon-pc" "simon-laptop" "server-schweiz" "server-wien" ];
      versioning = { type = "trashcan"; };
    };
  };
}
