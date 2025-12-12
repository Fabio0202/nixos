# ../modules/syncthing/default.nix
{ user
, hostName
,
}:
let
  # Dynamically construct the folder path based on the user
  foldersFile = ./folders + "/${hostName}.nix";
in
{
  imports = [
    (import ./settings.nix { inherit user; })
    ./devices.nix
    foldersFile
  ];
}
