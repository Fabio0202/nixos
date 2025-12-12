{
  pkgs,
  pkgs-unstable,
  ...
}: let
  mainMod = "Super";
in {
  home.packages = with pkgs; [
    (pkgs-unstable.vintagestory)
    # blocky
    telegram-desktop
    vi-mongo # mongo db gui client
    chromium
    redisinsight # redis gui client
    teams-for-linux
    jetbrains.webstorm
    (pkgs-unstable.mongodb-compass)
    logseq # notetaking like obsidian but better
    bitwig-studio
    gitkraken # git gui client
    slack # work chat
    monolith # save complete web pages as a single HTML file
    presenterm # for presentations in the terminal
    filezilla # for sending files to my webserver
    posting # to test http requests like postman
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

  wayland.windowManager.hyprland.settings.bind = [
    "${mainMod}, return, exec, rofi -config ~/.config/rofi/rofi-glass.rasi -show drun" ## System | Toggle Wofi
  ];
}
