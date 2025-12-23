# Migration Guide: Stow + Theme Switching

This guide outlines the migration from the current hybrid Nix+configfiles approach to a Stow-based system with dynamic theme switching capabilities.

## Overview

### Current State
- **Nix**: Package management, Stylix configuration, some Home Manager configs
- **configfiles/**: Manual configs managed via `home.file.*` with hardcoded colors
- **Partial Stow**: Hyprland config already moved to Stow
- **Static theming**: Theme changes require Nix rebuilds

### Target State
- **Nix**: Package management, base Stylix configuration
- **Stow**: All application configs with template-based theming
- **Dynamic theming**: Runtime theme switching without rebuilds
- **Unified system**: Consistent colors across all applications

## Phase 1: Stow Migration

### 1.1 Directory Structure Setup

Create the new Stow structure:

```bash
mkdir -p dotfiles/stow-common/{rofi,wofi,waybar,wlogout,swaylock,nwg-dock,scripts}
mkdir -p dotfiles/stow-simon/hyprland
mkdir -p dotfiles/stow-fabio/hyprland
```

### 1.2 Migration Priority

#### High Priority (Theme-heavy configs)
Move these first as they'll benefit most from the theme system:

1. **Rofi** (`home/configfiles/rofi/` → `dotfiles/stow-common/rofi/.config/rofi/`)
2. **Wofi** (`home/configfiles/wofi/` → `dotfiles/stow-common/wofi/.config/wofi/`)
3. **Waybar** (`home/configfiles/waybar/` → `dotfiles/stow-common/waybar/.config/waybar/`)
4. **Wlogout** (`home/configfiles/wlogout/` → `dotfiles/stow-common/wlogout/.config/wlogout/`)
5. **Swaylock** (`home/configfiles/swaylock/` → `dotfiles/stow-common/swaylock/.config/swaylock/`)

#### Medium Priority (Utilities)
6. **nwg-dock** (`home/configfiles/nwg-dock-hyprland/` → `dotfiles/stow-common/nwg-dock/.config/nwg-dock-hyprland/`)
7. **Scripts** (`home/scripts/` → `dotfiles/stow-common/scripts/.local/bin/`)

#### Low Priority (User-specific)
8. **User Hyprland configs** (create user-specific overrides)

### 1.3 Migration Steps

For each directory:

```bash
# Example for Rofi
cp -r home/configfiles/rofi/* dotfiles/stow-common/rofi/.config/rofi/
cd dotfiles
stow -v -t ~ stow-common/rofi
```

### 1.4 Update Nix Configuration

Remove `home.file.*` entries for migrated configs:

```nix
# Remove from home/modules/rofi.nix:
# home.file.".config/rofi/" = {
#   source = builtins.path {path = ../../configfiles/rofi;};
#   recursive = true;
# };

# Keep only package management:
home.packages = with pkgs; [ rofi ];
```

## Phase 2: Theme Infrastructure

### 2.1 Theme Definition System

Create `/home/modules/theme-manager.nix`:

```nix
{ config, pkgs, lib, ... }:
let
  themes = {
    catppuccin-mocha = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
      variant = "mocha";
      name = "Catppuccin Mocha";
    };
    catppuccin-frappe = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
      polarity = "dark";
      variant = "frappe";
      name = "Catppuccin Frappe";
    };
    catppuccin-latte = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
      polarity = "light";
      variant = "latte";
      name = "Catppuccin Latte";
    };
    gruvbox-dark = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      polarity = "dark";
      variant = "dark";
      name = "Gruvbox Dark";
    };
    nord = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      polarity = "dark";
      variant = "nord";
      name = "Nord";
    };
  };

  # Read current theme from file or use default
  currentThemeName = 
    let
      themeFile = config.xdg.configHome + "/themes/current";
    in
    if builtins.pathExists themeFile then
      lib.removeSuffix "\n" (builtins.readFile themeFile)
    else "catppuccin-mocha";
  
  currentTheme = themes.${currentThemeName} or themes.catppuccin-mocha;

in
{
  options = {
    theme.current = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin-mocha";
      description = "Current theme name";
    };
  };

  config = {
    # Stylix configuration
    stylix = {
      enable = true;
      base16Scheme = currentTheme.base16Scheme;
      polarity = currentTheme.polarity;
      autoEnable = false; # We'll enable targets selectively
      
      targets = {
        gtk.enable = true;
        qt.enable = true;
        kitty.enable = true;
        # Keep other targets as they are in current config
      };
    };

    # Make theme info available to other modules
    home.file.".config/themes/current".text = currentThemeName;
    home.file.".config/themes/available.json".text = builtins.toJSON themes;
  };
}
```

### 2.2 Template Processing System

Create `/home/modules/template-processor.nix`:

```nix
{ config, pkgs, lib, ... }:
let
  # Map Stylix colors to template variables
  stylixColors = {
    base00 = config.lib.stylix.colors.base00; # background
    base01 = config.lib.stylix.colors.base01; # lighter background
    base02 = config.lib.stylix.colors.base02; # selection background
    base03 = config.lib.stylix.colors.base03; # comments, invisibles
    base04 = config.lib.stylix.colors.base04; # foreground, invisibles
    base05 = config.lib.stylix.colors.base05; # default foreground
    base06 = config.lib.stylix.colors.base06; # light foreground
    base07 = config.lib.stylix.colors.base07; # light background
    base08 = config.lib.stylix.colors.base08; # variables, red
    base09 = config.lib.stylix.colors.base09; # integers, orange
    base0A = config.lib.stylix.colors.base0A; # classes, yellow
    base0B = config.lib.stylix.colors.base0B; # strings, green
    base0C = config.lib.stylix.colors.base0C; # support, cyan
    base0D = config.lib.stylix.colors.base0D; # functions, blue
    base0E = config.lib.stylix.colors.base0E; # keywords, magenta
    base0F = config.lib.stylix.colors.base0F; # deprecated, pink
  };

  # Process template by replacing @variables@ with actual colors
  processTemplate = template: colors:
    builtins.replaceStrings
      (map (c: "@${c}@") (lib.attrNames colors))
      (lib.attrValues colors)
      (builtins.readFile template);

  # Generate CSS custom properties
  generateCSSProperties = colors:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "@define-color ${name} ${value};") colors
    );

in
{
  # This module provides utilities for other modules to use
  config = {
    # Export color processing functions
    lib.theme = {
      inherit processTemplate generateCSSProperties stylixColors;
    };
  };
}
```

## Phase 3: Theme Templates

### 3.1 Create Template Directory Structure

```bash
mkdir -p dotfiles/themes/{catppuccin-mocha,catppuccin-frappe,catppuccin-latte,gruvbox-dark,nord}
mkdir -p dotfiles/themes/common
```

### 3.2 Convert Existing Configs to Templates

#### Waybar Template (`dotfiles/themes/common/waybar.css.template`)

```css
/* Waybar Theme Template */
@define-color base00 @base00@;
@define-color base01 @base01@;
@define-color base02 @base02@;
@define-color base03 @base03@;
@define-color base04 @base04@;
@define-color base05 @base05@;
@define-color base06 @base06@;
@define-color base07 @base07@;
@define-color base08 @base08@;
@define-color base09 @base09@;
@define-color base0A @base0A@;
@define-color base0B @base0B@;
@define-color base0C @base0C@;
@define-color base0D @base0D@;
@define-color base0E @base0E@;
@define-color base0F @base0F@;

* {
    border: none;
    border-radius: 0;
    font-family: "JetBrains Mono Nerd Font", sans-serif;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: @base00@;
    color: @base05@;
}

#workspaces {
    background: @base01@;
    margin: 5px 5px;
    border-radius: 8px;
}

#workspaces button {
    color: @base05@;
    background: transparent;
    border-radius: 8px;
    padding: 0 10px;
    margin: 2px;
}

#workspaces button.active {
    background: @base0D@;
    color: @base00@;
}

#clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
    background: @base01@;
    margin: 5px 5px;
    border-radius: 8px;
    padding: 0 10px;
}

#battery.charging {
    background: @base0B@;
    color: @base00@;
}

#battery.warning:not(.charging) {
    background: @base09@;
    color: @base00@;
}

#battery.critical:not(.charging) {
    background: @base08@;
    color: @base00@;
}
```

#### Rofi Template (`dotfiles/themes/common/rofi.rasi.template`)

```rasi
/* Rofi Theme Template */
* {
    bg0:  @base00@;
    bg1:  @base01@;
    bg2:  @base02@;
    bg3:  @base03@;
    fg0:  @base05@;
    fg1:  @base06@;
    fg2:  @base07@;
    ac0:  @base08@;
    ac1:  @base09@;
    ac2:  @base0A@;
    ac3:  @base0B@;
    ac4:  @base0C@;
    ac5:  @base0D@;
    ac6:  @base0E@;
    ac7:  @base0F@;
}

configuration {
    modi: "drun,run";
    font: "JetBrains Mono Nerd Font 12";
    show-icons: true;
    icon-theme: "Papirus-Dark";
}

window {
    transparency: "real";
    background-color: @bg0@;
    text-color: @fg0@;
    border: 2px;
    border-color: @bg2@;
    border-radius: 8px;
    width: 50%;
    padding: 20px;
}

mainbox {
    background-color: @bg0@;
    children: [inputbar, listview];
}

inputbar {
    background-color: @bg1@;
    border-radius: 6px;
    padding: 8px 12px;
    margin: 0 0 10px 0;
}

element {
    background-color: @bg0@;
    text-color: @fg0@;
    border-radius: 6px;
    padding: 8px 12px;
    margin: 2px 0;
}

element selected {
    background-color: @ac5@;
    text-color: @bg0@;
}

element-text, element-icon {
    background-color: transparent;
}
```

### 3.3 Theme-Specific Customizations

Create theme-specific override files for unique styling:

```bash
# Example: dotfiles/themes/catppuccin-mocha/waybar-overrides.css
window#waybar {
    border-bottom: 2px solid #cba6f7; /* Catppuccin accent */
}

#workspaces button.active {
    background: linear-gradient(45deg, #89b4fa, #b4befe);
}
```

## Phase 4: Runtime Theme Switching

### 4.1 Theme Switching Script

Create `dotfiles/stow-common/scripts/.local/bin/switch-theme`:

```bash
#!/bin/bash
# Theme switching script

set -euo pipefail

THEME_DIR="$HOME/.config/themes"
CURRENT_FILE="$THEME_DIR/current"
AVAILABLE_FILE="$THEME_DIR/available.json"
DOTFILES_DIR="$HOME/dotfiles"

# Available themes (should match theme-manager.nix)
AVAILABLE_THEMES=("catppuccin-mocha" "catppuccin-frappe" "catppuccin-latte" "gruvbox-dark" "nord")

log() {
    echo "[theme] $1"
}

error() {
    echo "[theme] ERROR: $1" >&2
    exit 1
}

show_usage() {
    echo "Usage: $0 <theme-name>"
    echo "Available themes: ${AVAILABLE_THEMES[*]}"
    echo ""
    echo "Commands:"
    echo "  switch-theme <theme>    Switch to specified theme"
    echo "  switch-theme list       List available themes"
    echo "  switch-theme current     Show current theme"
    echo "  switch-theme auto       Auto-detect theme based on time"
}

validate_theme() {
    local theme="$1"
    if [[ ! " ${AVAILABLE_THEMES[@]} " =~ " ${theme} " ]]; then
        error "Unknown theme '$theme'. Available: ${AVAILABLE_THEMES[*]}"
    fi
}

get_current_theme() {
    if [[ -f "$CURRENT_FILE" ]]; then
        cat "$CURRENT_FILE"
    else
        echo "catppuccin-mocha"
    fi
}

apply_theme() {
    local theme="$1"
    log "Applying theme: $theme"
    
    # Update current theme file
    echo "$theme" > "$CURRENT_FILE"
    
    # Apply theme to different components
    apply_waybar_theme "$theme"
    apply_rofi_theme "$theme"
    apply_wofi_theme "$theme"
    apply_wlogout_theme "$theme"
    apply_swaylock_theme "$theme"
    
    # Restart affected services
    restart_services
    
    log "Theme '$theme' applied successfully"
}

apply_waybar_theme() {
    local theme="$1"
    local template_file="$DOTFILES_DIR/themes/common/waybar.css.template"
    local override_file="$DOTFILES_DIR/themes/$theme/waybar-overrides.css"
    local output_file="$HOME/.config/waybar/style.css"
    
    log "Updating Waybar theme..."
    
    # Process template with current Stylix colors
    if [[ -f "$template_file" ]]; then
        # Get colors from Stylix (this requires integration with Nix)
        "$HOME/.local/bin/process-template" "$template_file" "$output_file"
        
        # Apply theme-specific overrides if they exist
        if [[ -f "$override_file" ]]; then
            echo "" >> "$output_file"
            cat "$override_file" >> "$output_file"
        fi
        
        # Reload Waybar
        pkill -USR1 waybar || true
    fi
}

apply_rofi_theme() {
    local theme="$1"
    local template_file="$DOTFILES_DIR/themes/common/rofi.rasi.template"
    local output_file="$HOME/.config/rofi/current-theme.rasi"
    
    log "Updating Rofi theme..."
    
    if [[ -f "$template_file" ]]; then
        "$HOME/.local/bin/process-template" "$template_file" "$output_file"
    fi
}

apply_wofi_theme() {
    local theme="$1"
    local theme_dir="$DOTFILES_DIR/themes/$theme/wofi"
    local output_dir="$HOME/.config/wofi"
    
    log "Updating Wofi theme..."
    
    if [[ -d "$theme_dir" ]]; then
        cp -r "$theme_dir"/* "$output_dir/"
    fi
}

apply_wlogout_theme() {
    local theme="$1"
    local template_file="$DOTFILES_DIR/themes/common/wlogout.css.template"
    local output_file="$HOME/.config/wlogout/colors.css"
    
    log "Updating wlogout theme..."
    
    if [[ -f "$template_file" ]]; then
        "$HOME/.local/bin/process-template" "$template_file" "$output_file"
    fi
}

apply_swaylock_theme() {
    local theme="$1"
    local template_file="$DOTFILES_DIR/themes/common/swaylock.conf.template"
    local output_file="$HOME/.config/swaylock/config"
    
    log "Updating Swaylock theme..."
    
    if [[ -f "$template_file" ]]; then
        "$HOME/.local/bin/process-template" "$template_file" "$output_file"
    fi
}

restart_services() {
    log "Restarting affected services..."
    
    # Restart Waybar
    if pgrep -x waybar > /dev/null; then
        pkill -USR1 waybar
    fi
    
    # Reload Hyprland (optional, for border colors etc.)
    if pgrep -x Hyprland > /dev/null; then
        hyprctl reload
    fi
}

auto_theme() {
    local hour=$(date +%H)
    local theme
    
    # Light theme during day (8:00 - 18:00), dark theme otherwise
    if [[ $hour -ge 8 && $hour -le 18 ]]; then
        theme="catppuccin-latte"
    else
        theme="catppuccin-mocha"
    fi
    
    log "Auto-detected theme: $theme (hour: $hour)"
    apply_theme "$theme"
}

# Main script logic
case "${1:-}" in
    "list")
        echo "Available themes:"
        for theme in "${AVAILABLE_THEMES[@]}"; do
            current=""
            if [[ "$theme" == "$(get_current_theme)" ]]; then
                current=" (current)"
            fi
            echo "  $theme$current"
        done
        ;;
    "current")
        echo "Current theme: $(get_current_theme)"
        ;;
    "auto")
        auto_theme
        ;;
    "")
        show_usage
        exit 1
        ;;
    *)
        validate_theme "$1"
        apply_theme "$1"
        ;;
esac
```

### 4.2 Template Processor Script

Create `dotfiles/stow-common/scripts/.local/bin/process-template`:

```bash
#!/bin/bash
# Template processor for theme variables

set -euo pipefail

TEMPLATE_FILE="$1"
OUTPUT_FILE="$2"

# Get current colors from Stylix
# This is a simplified version - in practice, you'd want to read from Nix
get_stylix_colors() {
    # This would ideally read from the current Nix configuration
    # For now, we'll use a fallback method
    cat << EOF
base00=#1e1e2e
base01=#181825
base02=#313244
base03=#45475a
base04=#585b70
base05=#cdd6f4
base06=#f5e0dc
base07=#b4befe
base08=#f38ba8
base09=#fab387
base0A=#f9e2af
base0B=#a6e3a1
base0C=#94e2d5
base0D=#89b4fa
base0E=#cba6f7
base0F=#f2cdcd
EOF
}

# Process template
process_template() {
    local template="$1"
    local colors
    
    # Read colors
    colors=$(get_stylix_colors)
    
    # Process template by replacing @variables@ with actual values
    while IFS='=' read -r var value; do
        template="${template//@$var@/$value}"
    done <<< "$colors"
    
    echo "$template"
}

# Main
if [[ ! -f "$TEMPLATE_FILE" ]]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found" >&2
    exit 1
fi

result=$(process_template "$(<"$TEMPLATE_FILE")")
echo "$result" > "$OUTPUT_FILE"

echo "Processed template: $TEMPLATE_FILE -> $OUTPUT_FILE"
```

### 4.3 Theme Selector Interface

Create `dotfiles/stow-common/scripts/.local/bin/theme-selector`:

```bash
#!/bin/bash
# Interactive theme selector using rofi/wofi

AVAILABLE_THEMES=("catppuccin-mocha" "catppuccin-frappe" "catppuccin-latte" "gruvbox-dark" "nord")
THEME_DISPLAY_NAMES=("Catppuccin Mocha" "Catppuccin Frappe" "Catppuccin Latte" "Gruvbox Dark" "Nord")

# Get current theme
current_theme=$(switch-theme current 2>/dev/null | cut -d' ' -f3)

# Create menu with current theme marked
menu_items=()
for i in "${!AVAILABLE_THEMES[@]}"; do
    theme="${AVAILABLE_THEMES[$i]}"
    display="${THEME_DISPLAY_NAMES[$i]}"
    
    if [[ "$theme" == "$current_theme" ]]; then
        display="$display ✓"
    fi
    
    menu_items+=("$display")
done

# Show selection menu
if command -v wofi >/dev/null 2>&1; then
    selected=$(printf '%s\n' "${menu_items[@]}" | wofi --dmenu --prompt "Select theme:")
elif command -v rofi >/dev/null 2>&1; then
    selected=$(printf '%s\n' "${menu_items[@]}" | rofi -dmenu -p "Select theme:")
else
    echo "Error: Neither wofi nor rofi found" >&2
    exit 1
fi

# Find selected theme
for i in "${!menu_items[@]}"; do
    if [[ "${menu_items[$i]}" == "$selected" ]]; then
        switch-theme "${AVAILABLE_THEMES[$i]}"
        break
    fi
done
```

## Phase 5: Integration

### 5.1 Update Home Manager Configuration

Update user configurations to include the new theme system:

```nix
# home/simon/common-gui.nix (and fabio equivalent)
{ pkgs, inputs, ... }:
{
  imports = [
    ../modules/theme-manager.nix
    ../modules/template-processor.nix
    # ... other imports
  ];

  # Add theme switching tools
  home.packages = with pkgs; [
    # Theme switching scripts (from Stow)
    # ... other packages
  ];

  # Enable theme manager
  theme-manager.enable = true;
}
```

### 5.2 Create Systemd Service for Auto Theme

Create `dotfiles/stow-common/scripts/.config/systemd/user/auto-theme.service`:

```ini
[Unit]
Description=Auto Theme Switcher
After=graphical-session.target

[Service]
Type=oneshot
ExecStart=%h/.local/bin/switch-theme auto

[Install]
WantedBy=graphical-session.target
```

And timer `auto-theme.timer`:

```ini
[Unit]
Description=Run auto theme switcher every hour

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
```

## Phase 6: Migration Timeline

### Week 1: Foundation
- [ ] Create Stow directory structure
- [ ] Migrate high-priority configs (Rofi, Wofi, Waybar)
- [ ] Set up basic theme manager module
- [ ] Test Stow functionality

### Week 2: Templates
- [ ] Convert configs to templates
- [ ] Create template processor
- [ ] Implement basic theme switching
- [ ] Test theme switching functionality

### Week 3: Integration
- [ ] Migrate remaining configs
- [ ] Create theme selector interface
- [ ] Set up auto-theme service
- [ ] Update Nix configurations

### Week 4: Polish
- [ ] Add more themes
- [ ] Create theme customization tools
- [ ] Document the new system
- [ ] Clean up old configfiles

## Verification Steps

### After Each Phase

1. **Stow Migration**:
   ```bash
   stow -t ~ -d dotfiles stow-common/rofi
   ls -la ~/.config/rofi/  # Verify symlinks
   ```

2. **Theme Switching**:
   ```bash
   switch-theme list
   switch-theme catppuccin-latte
   # Verify visual changes
   ```

3. **Auto Theme**:
   ```bash
   systemctl --user enable --now auto-theme.timer
   # Check if theme changes at appropriate times
   ```

### Final Verification

1. **All applications use consistent colors**
2. **Theme switching works without rebuilds**
3. **Auto-theme functions correctly**
4. **No broken symlinks or missing configs**
5. **Performance is acceptable**

## Troubleshooting

### Common Issues

1. **Broken symlinks after migration**:
   ```bash
   stow -t ~ -d dotfiles -D stow-common/rofi  # Unstow
   stow -t ~ -d dotfiles stow-common/rofi     # Restow
   ```

2. **Theme colors not updating**:
   - Check if template processor is working
   - Verify Stylix colors are accessible
   - Restart affected services

3. **Conflicts between Nix and Stow**:
   - Ensure `home.file.*` entries are removed
   - Check for duplicate config files
   - Verify Stow takes precedence

### Rollback Plan

If issues arise, you can rollback by:

1. **Disable Stow**:
   ```bash
   stow -t ~ -d dotfiles -D stow-common
   ```

2. **Restore Nix configs**:
   - Revert `home.file.*` changes
   - Run `home-manager switch`

3. **Gradual re-migration**:
   - Migrate one application at a time
   - Test thoroughly between migrations

## Benefits of This Migration

1. **Runtime Flexibility**: Change themes without system rebuilds
2. **Consistency**: Unified color system across all applications
3. **Maintainability**: Centralized theme management
4. **Portability**: Configs work on non-Nix systems
5. **Performance**: Faster theme iteration and testing
6. **User Experience**: Easy theme selection and automation

This migration transforms your static configuration into a dynamic, user-friendly theming system while maintaining the benefits of Nix declarative management.