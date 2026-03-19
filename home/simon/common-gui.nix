{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs-unstable.vintagestory)
    nomachine-client
    _1password-gui # 1Password password manager (GUI)
    bun
    comma
    nix-index
    (pkgs-unstable.walker)
    (pkgs-unstable.elephant)
    (pkgs-unstable.telegram-desktop)
    (pkgs-unstable.chromium)
    teams-for-linux
    vi-mongo # mongo db tui client
    godot
    logseq # notetaking like obsidian but better
    (pkgs-unstable.bitwig-studio)
    filezilla # for sending files to my webserver
    warehouse # GUI flatpak manager
    # gitkraken # git gui client - temporarily disabled due to download issues
    # slack # work chat
    # monolith # save complete web pages as a single HTML file
    # presenterm # for presentations in the terminal
    # posting # to test http requests like postman
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
