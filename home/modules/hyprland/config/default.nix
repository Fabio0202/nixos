{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    rose-pine-cursor
  ];

  home.sessionVariables = {
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "rose-pine-cursor";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs-unstable.hyprland;
    # Keep generating hyprland.conf (not .lua) — our config lives in stow'd
    # hyprlang .conf files (animations.conf, keybinds.conf, etc.),
    # not in Hyprland's new hl.* Lua API.
    configType = "hyprlang";
    extraConfig = ''
      source = ~/.config/hypr/hyprland-stow.conf
    '';
  };
}
