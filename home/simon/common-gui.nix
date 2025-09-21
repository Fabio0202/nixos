{
  pkgs,
  pkgs-unstable,
  ...
}: {
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
    filezilla
  ];

  imports = [
    # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
  ];
}
