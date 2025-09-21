# syncthing.nix
{user}: {
  services.syncthing = {
    enable = true;
    inherit user;
    guiAddress = "0.0.0.0:8384";
    dataDir = "/home/${user}/.local/share/syncthing";
    configDir = "/home/${user}/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
  };
}
