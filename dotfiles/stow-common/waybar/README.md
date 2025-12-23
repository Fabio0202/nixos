# Waybar Configuration with Dynamic Theming

This directory contains the Waybar configuration with a template-based theming system that allows runtime theme switching without requiring Nix rebuilds.

## Structure

```
dotfiles/stow-common/waybar/.config/waybar/
├── config.jsonc              # Main Waybar configuration
└── style.css                 # Generated theme file (do not edit)

dotfiles/themes/
├── common/
│   └── waybar.css.template   # Base template with @variables@
├── catppuccin-mocha/
│   └── waybar-overrides.css  # Theme-specific customizations
├── catppuccin-frappe/
│   └── waybar-overrides.css
├── catppuccin-latte/
│   └── waybar-overrides.css
├── gruvbox-dark/
│   └── waybar-overrides.css
└── nord/
    └── waybar-overrides.css

dotfiles/stow-common/scripts/.local/bin/
├── waybar-theme              # Theme switching script
├── process-template          # Template processor
└── test-waybar              # Test suite
```

## Features

### 1. Template-Based Theming
- Uses `@base00@`, `@base01@`, etc. variables in templates
- Variables are replaced with actual theme colors at runtime
- Supports 5 themes: Catppuccin Mocha/Frappe/Latte, Gruvbox Dark, Nord

### 2. Theme-Specific Overrides
Each theme can have custom CSS overrides for:
- Unique accent colors
- Special gradients and effects
- Theme-specific animations
- Custom styling for certain modules

### 3. Runtime Theme Switching
- Switch themes instantly without rebuilding
- Automatic Waybar reload after theme change
- Preserves all functionality and modules

## Usage

### Switching Themes

```bash
# Apply current theme
waybar-theme

# Apply specific theme
waybar-theme catppuccin-latte

# Set current theme and apply
echo "gruvbox-dark" > ~/.config/themes/current
waybar-theme
```

### Testing

```bash
# Run all tests
test-waybar

# Test specific components
test-waybar template    # Test template processing
test-waybar overrides   # Test override files
test-waybar script      # Test theme script
test-waybar config      # Test config syntax
```

### Manual Template Processing

```bash
# Process template for testing
process-template themes/common/waybar.css.template /tmp/output.css
```

## Available Themes

| Theme | Description | Colors |
|-------|-------------|--------|
| `catppuccin-mocha` | Dark Catppuccin Mocha | Dark purple/blue palette |
| `catppuccin-frappe` | Dark Catppuccin Frappe | Dark blue/gray palette |
| `catppuccin-latte` | Light Catppuccin Latte | Light pastel palette |
| `gruvbox-dark` | Dark Gruvbox | Warm dark palette |
| `nord` | Nord Theme | Cold blue/gray palette |

## Module Configuration

### Left Modules
- `hyprland/workspaces` - Workspace switcher
- `custom/music` - Current music track
- `cpu` - CPU usage
- `memory` - Memory usage
- `custom/cpu_temp` - CPU temperature

### Center Modules
- `clock` - Clock with date/time

### Right Modules
- `tray` - System tray
- `custom/kblayout` - Keyboard layout
- `pulseaudio` - Volume control
- `custom/mic` - Microphone mute status
- `backlight` - Screen brightness
- `custom/nightmode` - Night mode toggle
- `custom/notifications` - Notification center
- `custom/battery` - Battery status
- `custom/power` - Power menu

## Customization

### Adding New Themes

1. Create theme directory:
   ```bash
   mkdir dotfiles/themes/my-theme
   ```

2. Add color definitions to `process-template` script:
   ```bash
   "my-theme")
       cat << EOF
   base00=#1a1a1a
   base01=#2a2a2a
   # ... add all colors
   EOF
       ;;
   ```

3. Create theme overrides:
   ```bash
   touch dotfiles/themes/my-theme/waybar-overrides.css
   ```

4. Add to test script:
   ```bash
   THEMES=("catppuccin-mocha" "catppuccin-frappe" "catppuccin-latte" "gruvbox-dark" "nord" "my-theme")
   ```

### Modifying Modules

Edit `config.jsonc` to add, remove, or configure modules. The template system will automatically apply the current theme to all modules.

### Custom Styling

Add custom CSS to theme-specific override files. These are applied after the base template and can override any styling.

## Integration with Nix

To integrate with your Nix configuration:

1. **Stow the configuration:**
   ```bash
   cd dotfiles
   stow -t ~ stow-common/waybar
   ```

2. **Remove from Home Manager:**
   ```nix
   # Remove this from your Nix config:
   # home.file.".config/waybar/" = {
   #   source = builtins.path {path = ../../configfiles/waybar;};
   #   recursive = true;
   # };
   ```

3. **Add theme switching tools to packages:**
   ```nix
   home.packages = with pkgs; [
     # Theme switching scripts will be available via Stow
   ];
   ```

## Troubleshooting

### Theme Not Applying
- Check that `~/.config/themes/current` exists and contains a valid theme name
- Run `test-waybar` to verify the system is working
- Check Waybar logs: `journalctl --user -u waybar`

### Colors Not Updating
- Verify template variables are spelled correctly (`@base00@`, not `@baseO@`)
- Check that the theme color definitions exist in `process-template`
- Run `test-waybar template` to verify template processing

### Script Errors
- Ensure all scripts are executable: `chmod +x dotfiles/stow-common/scripts/.local/bin/*`
- Check that bash is at the correct path: `which bash`
- Verify all required directories exist

## Performance

The theme system is designed for minimal overhead:
- Template processing takes <100ms
- Theme switching is instant
- No background processes required
- Minimal memory footprint

## Future Enhancements

- [ ] Auto theme switching based on time of day
- [ ] Theme preview functionality
- [ ] Integration with system-wide theme manager
- [ ] Support for user-defined color schemes
- [ ] GUI theme selector
- [ ] Theme transition animations