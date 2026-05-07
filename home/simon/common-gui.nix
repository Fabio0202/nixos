{
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  ...
}: let
  # ── Change this one line to switch your default browser everywhere ──
  defaultBrowser = "chrome"; # "chrome" | "firefox"

  browser =
    {
      chrome = {
        desktop = "google-chrome.desktop";
        bin = "google-chrome-stable";
        wmClass = "google-chrome";
      };
      firefox = {
        desktop = "firefox.desktop";
        bin = "firefox";
        wmClass = "firefox";
      };
    }.${
      defaultBrowser
    };
in {
  home.packages = with pkgs; [
    (pkgs-unstable.vintagestory)
    discord # Voice, video, and text chat (gaming/community)
    spotify # Music streaming client
    inputs.helium.packages.${pkgs.system}.default
    (inputs.whisrs.packages.${pkgs.system}.default.overrideAttrs (_: {
      doCheck = false;
    }))
    anki # Flashcard-based learning tool (spaced repetition)
    libreoffice # Office suite (Word, Excel, PowerPoint, etc.)
    gnome-clocks # World clocks, stopwatch, timers, alarms
    qalculate-gtk # Advanced calculator with many features
    todoist-electron # Task management & to-do list app
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
    google-chrome
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

  # Browser MIME defaults — driven by `defaultBrowser` above
  xdg.mimeApps.defaultApplications = {
    "text/html" = [browser.desktop];
    "x-scheme-handler/http" = [browser.desktop];
    "x-scheme-handler/https" = [browser.desktop];
    "x-scheme-handler/ftp" = [browser.desktop];
  };

  # Hyprland: browser keybind + window rule — driven by `defaultBrowser` above
  wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
    bind = $mainMod, B, exec, ${browser.bin}
    windowrule = opacity 0.98 0.85, match:class ^(${browser.wmClass})$
    bind = $mainMod, V, exec, whisrs toggle
    bind = $mainMod SHIFT, V, exec, whisrs command
  '';

  # Chrome flags: native Wayland + hardware VA-API video decode
  xdg.configFile."google-chrome-flags.conf".text = ''
    --ozone-platform=auto
    --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder
    --ignore-gpu-blocklist
  '';

  xdg.desktopEntries.lf = {
    name = "lf";
    noDisplay = true; # hides it from rofi drun / menus
  };
  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file:///mnt/server Server
    file:///mnt/cloud My Cloud
  '';
  imports = [
    ../modules/hyprland/default.nix
    ../modules/python.nix
    ../modules/newsboat.nix
  ];
}
