{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs-unstable.vintagestory)
    discord # Voice, video, and text chat (gaming/community)
    spotify # Music streaming client
    anki # Flashcard-based learning tool (spaced repetition)
    libreoffice # Office suite (Word, Excel, PowerPoint, etc.)
    gnome-clocks # World clocks, stopwatch, timers, alarms
    qalculate-gtk # Advanced calculator with many features
    vscode # GUI code editor (Visual Studio Code)
    # nomachine-client # like rustdesk but faster I've heard but its not working so whatever
    _1password-gui # 1Password password manager (GUI)
    bun # like node but faster
    comma # to be able to run ", cowsay" for one time commands
    nix-index # to be able to run nix-locate
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
    # bruno like postman but cool
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
