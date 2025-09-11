# keybindings.nix
{pkgs, ...}: let
  mainMod = "Super";
in {
  wayland.windowManager.hyprland.settings.bindel = [
    # Brightness controls
    ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
    ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
  ];
  wayland.windowManager.hyprland.settings.bind = [
    # "${mainMod}, mouse_down, workspace, e+1"
    # "${mainMod}, TAB, exec, restore"
  ];
}
