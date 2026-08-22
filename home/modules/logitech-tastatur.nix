# keybindings.nix
{pkgs, ...}: let
  mainMod = "Super";
in {
  wayland.windowManager.hyprland.settings.bindel = [
    # Brightness controls (DDC/CI-aware, internal panels via brightnessctl)
    ", XF86MonBrightnessUp, exec, ~/.local/bin/brightness up"
    ", XF86MonBrightnessDown, exec, ~/.local/bin/brightness down"
  ];
  wayland.windowManager.hyprland.settings.bind = [
    # "${mainMod}, mouse_down, workspace, e+1"
    # "${mainMod}, TAB, exec, restore"
  ];
}
