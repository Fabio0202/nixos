{...}: {
  services.syncthing = {
    enable = true;
    user = "simon"; # run Syncthing as your user
    dataDir = "/home/simon/.config/syncthing";

    settings = {
      devices = {
        "laptop-fabio" = {
          id = "ACV25DB-CFQXIZE-6QN7ZHK-EZTTPKB-TJU7WM6-6JI7FMR-WYBTQIB-BG6J3AL";
          name = "fabio-laptop";
          introducer = false; # always trust this device
        };
      };

      folders = {
        "shared-docs" = {
          id = "shared-docs"; # unique folder ID inside Syncthing
          path = "/home/simon/testNew"; # folder on this machine
          devices = ["laptop-fabio"]; # share only with laptop
          type = "sendreceive"; # default mode
        };
      };
    };
  };
}
