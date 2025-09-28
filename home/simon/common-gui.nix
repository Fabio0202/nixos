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
    jetbrains.webstorm
    (pkgs-unstable.mongodb-compass)
    logseq # notetaking like obsidian but better
    gitkraken
    slack
    monolith # save complete web pages as a single HTML file
    presenterm
    filezilla
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
    ../modules/neovim/obsidian.nix
  ];

  wayland.windowManager.hyprland.settings.bind = [
    "${mainMod}, return, exec, rofi -config ~/.config/rofi/rofi-glass.rasi -show drun" ## System | Toggle Wofi
  ];
}
