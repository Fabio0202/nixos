{
  config,
  lib,
  ...
}: let
  # Default theme - change this to switch the default on fresh clones
  defaultTheme = "catppuccin-mocha";

  homeDir = config.home.homeDirectory;
  configDir = "${homeDir}/.config";
  stateDir = "${homeDir}/.local/state";

  # Theme file definitions: path -> type (symlink target or import content)
  themeFiles = {
    "${configDir}/kitty/themes/current.conf" = {
      type = "symlink";
      target = "${configDir}/kitty/themes/${defaultTheme}.conf";
    };
    "${configDir}/swaync/themes/current.css" = {
      type = "import";
      content = ''
        @import url("${defaultTheme}.css");
        @import url("base-styles.css");
      '';
    };
    "${configDir}/swayosd/themes/current.css" = {
      type = "import";
      content = ''
        @import url("${defaultTheme}.css");
        @import url("base-styles.css");
      '';
    };
    "${configDir}/telegram-themes/current.tdesktop-theme" = {
      type = "symlink";
      target = "${configDir}/telegram-themes/${defaultTheme}.tdesktop-theme";
    };
    "${configDir}/waybar/themes/current.css" = {
      type = "symlink";
      target = "${configDir}/waybar/themes/${defaultTheme}.css";
    };
    "${configDir}/nwg-dock-hyprland/style.css" = {
      type = "import";
      content = ''
        @import url("themes/${defaultTheme}.css");
        @import url("base-styles.css");
      '';
    };
    "${configDir}/wlogout/style.css" = {
      type = "import";
      content = ''
        @import url("themes/${defaultTheme}.css");
        @import url("base-styles.css");
      '';
    };
    "${stateDir}/theme/wallpapers.json" = {
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
      if [ -L "${path}" ]; then
        echo "Removing existing symlink: ${path}"
        rm -f "${path}"
      fi
      if [ ! -e "${path}" ]; then
        echo "Creating default theme symlink: ${path}"
        mkdir -p "$(dirname "${path}")"
        ln -sf "${cfg.target}" "${path}"
      fi
    ''
    else ''
      if [ -L "${path}" ]; then
        echo "Removing existing symlink: ${path}"
        rm -f "${path}"
      fi
      if [ ! -e "${path}" ]; then
        echo "Creating default theme file: ${path}"
        mkdir -p "$(dirname "${path}")"
        cat > "${path}" << 'THEMEEOF'
${cfg.content}THEMEEOF
      fi
    '')
  themeFiles);
in {
  home.activation.createThemeDefaults = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run bash -c ${lib.escapeShellArg createScript}
  '';
}
