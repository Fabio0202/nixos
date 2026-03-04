{
  pkgs,
  pkgs-unstable,
  ...
}: let
  mainMod = "Super";
in {
  home.packages = with pkgs; [
    (pkgs-unstable.vintagestory)
    nomachine-client

    _1password-gui # 1Password password manager (GUI)
    (pkgs-unstable.walker)
    (pkgs-unstable.elephant)
    # blocky
    (pkgs-unstable.telegram-desktop)
    vi-mongo # mongo db gui client
    (pkgs-unstable.godot_4)
    (pkgs-unstable.chromium)

    # teams-for-linux
    # (pkgs-unstable.jetbrains.webstorm)
    (pkgs-unstable.mongodb-compass)
    logseq # notetaking like obsidian but better
    (pkgs-unstable.bitwig-studio)
    # gitkraken # git gui client - temporarily disabled due to download issues
    # slack # work chat
    # monolith # save complete web pages as a single HTML file
    # presenterm # for presentations in the terminal
    filezilla # for sending files to my webserver
    posting # to test http requests like postman
    warehouse # GUI flatpak manager
  ];

  xdg.desktopEntries.lf = {
    name = "lf";
    noDisplay = true; # hides it from rofi drun / menus
  };
  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file:///mnt/server Server
    file:///mnt/cloud My Cloud
  '';
  imports = [
    # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
    ../modules/python.nix
    ../modules/neovim/obsidian.nix
  ];
}
