# Theme System Enhancement Plan

## Current State
- Theme script: `dotfiles/stow-common/.local/bin/theme`
- Available themes: `catppuccin-latte-minimal`, `catppuccin-mocha`, `everforest`, `kanagawa`, `rose-pine`
- Current theme: `everforest` (detected from symlinks)
- Wallpaper management: `waypaper` with `Super+W` keybind
- Wallpapers stored in: `files/wallpapers/`

## Proposed Enhancements

### 1. Core Theme Cycling
- **Behavior**: `theme` with no arguments cycles to next theme
- **Detection**: Read current theme from existing symlinks (stateless approach)
- **Order**: Alphabetical with wraparound (last → first)
- **Backward compatibility**: `theme <name>` unchanged

### 2. Theme-Specific Wallpaper Directories
```
files/wallpapers/
├── dark/           # for catppuccin-mocha, kanagawa
├── light/          # for catppuccin-latte-minimal  
├── nature/         # for everforest
└── abstract/       # for rose-pine
```
- Each theme uses wallpapers from its designated directory
- Random wallpaper selection via `waypaper --set`
- Auto-save wallpaper for restore on startup

### 3. Rofi Theme Selector
- **Command**: `theme --rofi` to launch interactive selector
- **Keybind**: `Super+T` (suggested) for theme selection
- **Display**: Theme names with current theme styling
- **Features**: Live preview, search, instant apply

### 4. Configuration System
**Location**: `~/.config/theme-config/config.json`
```json
{
  "themes": {
    "catppuccin-mocha": {
      "wallpaper_dir": "dark",
      "display_name": "Catppuccin Mocha"
    }
  },
  "current_theme": "everforest"
}
```

## Implementation Phases

### Phase 1: Core Functionality
- [ ] Theme cycling without arguments
- [ ] Basic wallpaper directory support
- [ ] Theme configuration file creation
- [ ] Maintain symlink-based state detection

### Phase 2: Rofi Integration  
- [ ] Rofi theme selector script
- [ ] Keybind integration in Hyprland
- [ ] Live preview capabilities
- [ ] Theme search functionality

### Phase 3: Advanced Features
- [ ] Time-based theme switching
- [ ] Monitor-specific themes
- [ ] Application theme exceptions
- [ ] Theme transition animations

## Key Benefits
1. **Scalable**: Easy to add new themes and wallpaper categories
2. **Backward Compatible**: Existing `theme <name>` usage unchanged  
3. **Maintainable**: Centralized configuration, modular functions
4. **User-Friendly**: Both cycling and selection interfaces
5. **Integrated**: Coordinated theming across all apps + wallpapers

## Technical Decisions

### State Management: Stateless ✅
- Read current theme from existing symlinks
- No external state files needed
- Leverages existing infrastructure

### Wallpaper Organization: Thematic ✅
- Organize by aesthetic (dark/light/nature/abstract)
- More flexible than theme-specific folders
- Allows mixing themes with similar aesthetics

### Configuration: JSON ✅  
- Easy programmatic access
- Human-readable and editable
- Extensible for future features

## Migration Strategy
1. Create new theme functions alongside existing code
2. Maintain symlink detection as fallback
3. Gradual migration to configuration-based approach
4. Preserve existing user preferences and wallpapers