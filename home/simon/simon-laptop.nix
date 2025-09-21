{
  pkgs,
  pkgs-unstable,
  ...
}: let
  username = "simon";
  homeDirectory = "/home/${username}";
in {
  # I need to permit insecure packages because of logseq for now
  home.packages = with pkgs; [
    # alle Software die ich nur am Laptop haben will
    telegram-desktop
    # TODO: allow unstable imports
    # (pkgs-unstable.vintagestory)
    # (pkgs-unstable.mongodb-compass)

    redis
    direnv # Manage environment variables per project directory
    (pkgs-unstable.devenv) # Dev environment manager (like direnv but more powerful)
    logseq # notetaking like obsidian but better
    gitkraken
    filezilla

    # Torrents
    deluge # torrent client
    slack

    monolith # save complete web pages as a single HTML file
    mdcat # render Markdown in terminal
    lsof # list open files and processes
    # blocky
  ];

  programs = {
    awscli = {
      enable = true;
      package = pkgs.awscli2; # v2 is recommended
    };
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };

  imports = [
    ../common.nix
    ../modules/battery-monitor.nix
    ../modules/hyprland/hypridle.nix
    ../modules/gitSimon.nix
  ];

  home = {
    inherit username;
    inherit homeDirectory;
    stateVersion = "25.11";
  };

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "us, de";
    sensitivity = 1.4;
  };
}
