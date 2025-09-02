{pkgs, ...}: {
  home.packages = with pkgs; [
    syncthing
    obsidian
    dysk # zeigt wieviel Speicher frei ist auf Festplatte
    ncdu #Welcher Folder wieviel Speicher
    libreoffice
    unzip
    # ffmpeg # videodateien formatieren und bearbeiten
    libreoffice
    git
    neovim
    vscode
    # libnotify # für Notifications
    lazygit
  ];
  imports = [
    ./modules/neovim/nvf.nix
    ./modules/taskwarrior.nix
    ./modules/sh.nix
    # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
  ];
}
