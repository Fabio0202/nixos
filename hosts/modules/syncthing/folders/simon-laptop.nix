{config, ...}: {
  services.syncthing.folders = {
    "/home/simon/Documents" = {
      devices = ["simon-laptop" "server-schweiz"];
      versioning = {type = "trashcan";};
    };
    "/home/simon/.task" = {
      devices = ["simon-laptop" "server-schweiz"];
      versioning = {type = "trashcan";};
    };
  };
}
