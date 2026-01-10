{
  config,
  lib,
  ...
}: let
  # Default theme - change this to switch the default on fresh clones
  defaultTheme = "catppuccin-mocha";

  # Base path for stow dotfiles in the nixos repo
  stowBase = "/home/simon/nixos/dotfiles/stow-common/.config";

  # Theme file definitions: path -> type (symlink target or import content)
  themeFiles = {
    "${stowBase}/kitty/themes/current.conf" = {
      type = "symlink";
      target = "${stowBase}/kitty/themes/${defaultTheme}.conf";
    };
    "${stowBase}/swaync/themes/current.css" = {
      type = "symlink";
      target = "${stowBase}/swaync/themes/${defaultTheme}.css";
    };
    "${stowBase}/swayosd/themes/current.css" = {
      type = "symlink";
      target = "${stowBase}/swayosd/themes/${defaultTheme}.css";
    };
    "${stowBase}/telegram-themes/current.tdesktop-theme" = {
      type = "symlink";
      target = "${stowBase}/telegram-themes/${defaultTheme}.tdesktop-theme";
    };
    "${stowBase}/waybar/themes/current.css" = {
      type = "symlink";
      # Points to installed location since waybar reads from ~/.config
      target = "/home/simon/.config/waybar/themes/${defaultTheme}.css";
    };
    "${stowBase}/nwg-dock-hyprland/style.css" = {
      type = "import";
      content = ''
        @import url("themes/${defaultTheme}.css");
        @import url("base-styles.css");
      '';
    };
    "${stowBase}/wlogout/style.css" = {
      type = "import";
      content = ''
        @import url("themes/${defaultTheme}.css");
        @import url("base-styles.css");
      '';
    };
    "/home/simon/nixos/files/wallpapers/.theme-state.json" = {
      type = "json";
      content = ''
        {
          "catppuccin-mocha": "dark-mountains.jpg",
          "catppuccin-latte-minimal": "light-minimal.jpg",
          "everforest": "forest-fern.jpg"
        }
      '';
    };
  };

  # Generate shell script to create missing files
  createScript = lib.concatStringsSep "\n" (lib.mapAttrsToList (path: cfg:
    if cfg.type == "symlink"
    then ''
      if [ ! -e "${path}" ]; then
        echo "Creating default theme symlink: ${path}"
        ln -sf "${cfg.target}" "${path}"
      fi
    ''
    else ''
      if [ ! -e "${path}" ]; then
        echo "Creating default theme file: ${path}"
        cat > "${path}" << 'THEMEEOF'
${cfg.content}THEMEEOF
      fi
    '')
  themeFiles);
in {
  home.activation.createThemeDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${createScript}
  '';
}
