{ config
, lib
, ...
}:
# This module creates default theme symlinks/files ONCE on fresh clones.
# It only writes if the target does not exist yet — never overwrites.
# Runtime theme switching is handled by the `theme` script (~/.local/bin/theme).
# The DAG chain ensures: prepStowDirs → stowDotfiles → fixMutableThemeFiles → createThemeDefaults.
let
  # Default theme - change this to switch the default on fresh clones
  defaultTheme = "catppuccin-mocha";

  homeDir = config.home.homeDirectory;
  configDir = "${homeDir}/.config";
  stateDir = "${homeDir}/.local/state";

  # Theme file definitions: path -> type (symlink target or import content)
  themeFiles = {
    "${configDir}/hypr/themes/current.conf" = {
      type = "symlink";
      target = "${configDir}/hypr/themes/${defaultTheme}.conf";
    };
    "${configDir}/kitty/themes/current.conf" = {
      type = "symlink";
      target = "${configDir}/kitty/themes/${defaultTheme}.conf";
    };
    "${configDir}/rofi/config.rasi" = {
      type = "symlink";
      target = "${configDir}/rofi/${defaultTheme}.rasi";
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
    "${configDir}/dgop/colors.json" = {
      type = "copy";
      source = "${homeDir}/nixos/dotfiles/stow-common/.config/dgop/colors.json";
    };
    "${stateDir}/DankMaterialShell/session.json" = {
      type = "copy";
      source = "${homeDir}/nixos/dotfiles/stow-common/.local/state/DankMaterialShell/session.json";
    };
  };

  # Generate shell script to create missing files (only on fresh clones)
  # Never removes existing files or symlinks - respects stow-managed configs
  createScript = ''
    ensure_parent_dir() {
      local parent
      parent="$(dirname "$1")"
      if [ ! -e "$parent" ]; then
        mkdir -p "$parent"
      fi
    }
  '' + lib.concatStringsSep "\n" (lib.mapAttrsToList
    (path: cfg:
      if cfg.type == "symlink"
      then ''
        # Only create if nothing exists (not even a symlink)
        if [ ! -e "${path}" ] && [ ! -L "${path}" ]; then
          echo "Creating default theme symlink: ${path}"
          ensure_parent_dir "${path}"
          ln -sf "${cfg.target}" "${path}"
        fi
      ''
      else if cfg.type == "copy"
      then ''
        # Only create if nothing exists (not even a symlink)
        if [ ! -e "${path}" ] && [ ! -L "${path}" ]; then
          echo "Creating default theme copy: ${path}"
          ensure_parent_dir "${path}"
          cp "${cfg.source}" "${path}"
        fi
      ''
      else ''
        # Only create if nothing exists (not even a symlink)
        if [ ! -e "${path}" ] && [ ! -L "${path}" ]; then
          echo "Creating default theme file: ${path}"
          ensure_parent_dir "${path}"
          cat > "${path}" << 'THEMEEOF'
${cfg.content}THEMEEOF
        fi
      '')
    themeFiles);
in
{
  home.activation.createThemeDefaults = lib.hm.dag.entryAfter [ "fixMutableThemeFiles" ] ''
    run bash -c ${lib.escapeShellArg createScript}
  '';
}
