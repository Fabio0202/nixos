{ ... }: {
  services.syncthing.folders = {
    "documents-fabio" = {
      # this is the folder ID (shared across devices)
      path = "/home/fabio/Documents"; # local path on this machine
      devices = [ "server-wien" "fabio-laptop-windows" "fabio-laptop-hp" "fabio-pc" "server-schweiz" ];
      versioning = { type = "trashcan"; };
    };

    "shared" = {
      # this is the folder ID (shared across devices)
      path = "/home/simon/shared/"; # local path on this machine
      devices = [ "simon-pc" "simon-laptop" "server-schweiz" "server-wien" "fabio-laptop-hp" "fabio-pc" ];
      versioning = { type = "trashcan"; };
    };
    "task-fabio" = {
      # another folder ID
      path = "/home/fabio/.task";
      devices = [ "server-wien" "fabio-laptop-hp" "fabio-pc" "server-schweiz" ];
      versioning = { type = "trashcan"; };
    };
  };
}
