{
  pkgs,
  inputs,
  ...
}: {
  # Plugins are installed via Nix, configuration is in stow (~/.config/hypr/)

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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
    ];
    # Minimal HM config - just load plugins and source stow-managed config
    extraConfig = ''
      source = ~/.config/hypr/hyprland-stow.conf
    '';
  };
}
