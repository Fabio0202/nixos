# ../modules/syncthing/default.nix
{user}: let
  # Dynamically construct the folder path based on the user
  foldersFile = ./folders + "/${user}.nix";
in {
  imports = [
    (import ./settings.nix {inherit user;})
    ./devices.nix
    foldersFile
  ];
}
