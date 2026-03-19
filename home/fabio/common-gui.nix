{
  pkgs,
  pkgs-unstable,
  ...
}: let
  mainMod = "Super";
in {
  # Sachen die du auf PC un laptops haben willst (also ohne server)
  home.packages = with pkgs; [
    (pkgs-unstable.vintagestory)
    imagej # Scientific image analysis (popular in research)
    gimp3-with-plugins # Advanced image editing (Photoshop alternative)
    obsidian # Note-taking with markdown and plugins
    discord # Voice, video, and text chat (gaming/community)
    spotify # Music streaming client
    anki # Flashcard-based learning tool (spaced repetition)
    libreoffice # Office suite (Word, Excel, PowerPoint, etc.)
    gnome-clocks # World clocks, stopwatch, timers, alarms
    vscode # GUI code editor (Visual Studio Code)
    qalculate-gtk # Advanced calculator with many features
    drawio # Diagram and flowchart creation
    blender # 3D modeling, animation, rendering
    veusz # Scientific plotting and graphing tool
    todoist-electron # Task management & to-do list app
    gitkraken # Shows Git Branches nicely
    arduino # für uni
    shotcut # Videoschneiden
  ];

  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file:///mnt/cloud My Cloud
  '';
  imports = [
    # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
    ../modules/python.nix
  ];
}
