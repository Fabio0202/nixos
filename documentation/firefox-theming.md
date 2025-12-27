# Firefox Theming Integration with GNU Stow

## Overview
Integrate Firefox theming into the existing unified theme switching system that already manages Kitty, Waybar, Rofi, swaync, swayosd, and nwg-dock.

## Current System Analysis
- **Theme Script**: `dotfiles/stow-common/.local/bin/theme`
- **Pattern**: Symlink-based switching with application restarts
- **Firefox Profile**: `/home/simon/.mozilla/firefox/z34ufndn.default/`
- **Theme Names**: `catppuccin-mocha`, `everforest`, `catppuccin-latte`, etc.

## Implementation Plan

### 1. Directory Structure
```
dotfiles/stow-common/.config/firefox-themes/
├── catppuccin-mocha/
│   └── chrome/
│       ├── userChrome.css
│       └── userContent.css
├── everforest/
│   └── chrome/
│       ├── userChrome.css  
│       └── userContent.css
└── catppuccin-latte/
    └── chrome/
        ├── userChrome.css
        └── userContent.css
```

### 2. Theme Script Extension
Add Firefox section to existing `theme` script:

```bash
# -------------------------
# Firefox
# -------------------------
FIREFOX_THEME_DIR="$HOME/.config/firefox-themes"
FIREFOX_PROFILE_DIR="$HOME/.mozilla/firefox/z34ufndn.default"
FIREFOX_CHROME_DIR="$FIREFOX_PROFILE_DIR/chrome"

if [ ! -f "$FIREFOX_THEME_DIR/$THEME_NAME/chrome/userChrome.css" ]; then
    echo "ℹ Firefox theme '$THEME_NAME' not found, skipping Firefox"
else
    mkdir -p "$FIREFOX_CHROME_DIR"
    rm -f "$FIREFOX_CHROME_DIR/userChrome.css" "$FIREFOX_CHROME_DIR/userContent.css"
    ln -sf "$FIREFOX_THEME_DIR/$THEME_NAME/chrome/userChrome.css" "$FIREFOX_CHROME_DIR/userChrome.css"
    ln -sf "$FIREFOX_THEME_DIR/$THEME_NAME/chrome/userContent.css" "$FIREFOX_CHROME_DIR/userContent.css"
    echo "✔ Firefox theme set to: $THEME_NAME"
    
    if pkill -f firefox; then
        echo "ℹ Firefox restarted - theme will apply on restart"
    else
        echo "ℹ Firefox not running - theme will apply on next start"
    fi
fi
```

### 3. Prerequisites

#### Firefox Configuration
1. Open Firefox and navigate to `about:config`
2. Enable legacy customizations:
   - Set `toolkit.legacyUserProfileCustomizations.stylesheets=true`

#### Theme Files
1. Create theme CSS files in the Firefox themes directory
2. Follow existing theme naming convention
3. Test with simple CSS initially

### 4. Integration Benefits

**Consistency**: One command themes all applications
**Maintenance**: Themes stored centrally in stow-common
**Flexibility**: Easy to add new Firefox themes
**Compatibility**: Follows existing system patterns

### 5. Implementation Steps

1. **Create Firefox theme directory structure**
2. **Add Firefox section to theme script**
3. **Create initial CSS theme files**
4. **Test theme switching**
5. **Document any Firefox-specific requirements**

### 6. Theme Development Notes

**userChrome.css**: Modifies Firefox UI (toolbars, tabs, menus)
**userContent.css**: Modifies web page appearance styling

**Recommended starting themes**:
- `catppuccin-mocha`: Match existing dark theme
- `catppuccin-latte`: Light variant
- `everforest`: Match another existing theme

### 7. Testing Procedure

1. Enable Firefox legacy customizations
2. Run `theme catppuccin-mocha`
3. Restart Firefox
4. Verify UI theme application
5. Test theme switching between different options

## Result

After implementation, Firefox theming will be integrated into the unified theme management system, allowing seamless theme switching across all configured applications with a single command.