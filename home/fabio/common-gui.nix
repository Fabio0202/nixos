{pkgs, ...}: {
  # Sachen die du auf PC un laptops haben willst (also ohne server)
  home.packages = with pkgs; [
    imagej # Scientific image analysis (popular in research)
    gimp3-with-plugins # Advanced image editing (Photoshop alternative)
    drawio # Diagram and flowchart creation
    blender # 3D modeling, animation, rendering
    veusz # Scientific plotting and graphing tool
    todoist # Task management & to-do list app
    gitkraken # Shows Git Branches nicely
  ];

  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file:///mnt/cloud My Cloud
  '';
  imports = [
    # hier kommen zB setup files aus /modules fuer die einzelnen pkgs bzw softwares
  ];
}
