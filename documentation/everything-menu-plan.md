# Everything Menu - Implementation Plan

## Overview
A Rofi-based "Command Center" with nested sub-menus, back navigation, and state-aware actions.

## Existing Infrastructure (Already Done)
- ✅ Rofi configured with themes (catppuccin-mocha, kanagawa, everforest)
- ✅ Theme switching script (`~/.local/bin/theme`)
- ✅ Screenshot keybinds (grim + slurp)
- ✅ playerctl installed
- ✅ hyprpicker installed
- ✅ wl-clipboard installed

## What Needs Building
- [ ] Core dispatcher script with back navigation
- [ ] NOPASSWD sudo rules for nixos-rebuild
- [ ] cliphist integration
- [ ] Sub-menus: System, Dev/Sync, Config, Utils, Media

---

## Step 1: Core Dispatcher & Navigation Logic

**Goal:** Create the main hub script with while-loop navigation and back button support.

**File:** `~/.local/bin/everything-menu`

**Structure:**
```
┌─────────────────────────┐
│   Everything Menu       │
├─────────────────────────┤
│ 󰒓  System              │ → Power, Audio, Network, Hyprsunset
│ 󰊢  Dev & Sync          │ → Git sync, Nix rebuild, Projects
│   Config              │ → Quick edit config files
│ 󰆏  Utils               │ → Screenshot, Clipboard, Calculator, Color
│ 󰎈  Media               │ → Now Playing, Controls
│ 󰗀  Styles              │ → Theme switcher
└─────────────────────────┘
```

**Logic Pattern:**
```bash
main_menu() {
    while true; do
        choice=$(echo -e "..." | rofi -dmenu -p "Menu")
        case "$choice" in
            *"System"*) system_menu ;;
            *"Back"*|"") break ;;
        esac
    done
}
```

**Deliverables:**
- [ ] `everything-menu.sh` - Main dispatcher script
- [ ] Nix module to package it as `pkgs.everything-menu`
- [ ] Keybind in hyprland (e.g., `Super+Space` or `Super+D`)

---

## Step 2: NixOS Security Setup (NOPASSWD)

**Goal:** Allow `nixos-rebuild` without password for routine maintenance.

**File:** `hosts/configuration-common.nix` (or per-host)

**Nix Config:**
```nix
security.sudo.extraRules = [
  {
    users = [ "simon" ];
    commands = [
      {
        command = "/run/current-system/sw/bin/nixos-rebuild";
        options = [ "NOPASSWD" ];
      }
    ];
  }
];
```

**Deliverables:**
- [ ] Add extraRules to configuration
- [ ] Verify with `sudo -l` after rebuild

---

## Step 3: System Sub-Menu

**Features:**
| Entry | Action |
|-------|--------|
| 󰐥 Shutdown | `systemctl poweroff` |
| 󰜉 Reboot | `systemctl reboot` |
| 󰤄 Suspend | `systemctl suspend` |
| 󰍃 Logout | `hyprctl dispatch exit` |
| 󰒳 Lock | `hyprlock` |
| 󰕾 Audio Output | `pavucontrol` or custom rofi picker |
| 󱩐 Hyprsunset | Toggle on/off with state check |
| ← Back | Return to main |

**Deliverables:**
- [ ] `system_menu()` function
- [ ] Hyprsunset toggle with state detection (`pgrep hyprsunset`)

---

## Step 4: Dev & Sync Sub-Menu

**Features:**
| Entry | Action |
|-------|--------|
| 󰊢 Git Sync | Pull/rebase dotfiles, handle conflicts |
| 󱄅 Nix Rebuild | `sudo nixos-rebuild switch --flake .` |
| 󰊢 Full Sync | Git pull + rebuild in sequence |
|  Projects | Dynamic picker from `~/projects/` → lazygit |
| ← Back | Return to main |

**Git Sync Logic:**
```bash
git_sync() {
    cd ~/nixos
    if git pull --rebase; then
        notify-send "Sync" "Pull successful"
    else
        kitty --title "Git Conflict" -e lazygit
    fi
}
```

**Deliverables:**
- [ ] `dev_menu()` function
- [ ] `git_sync()` helper
- [ ] `nix_rebuild()` helper (uses NOPASSWD)
- [ ] Dynamic project picker (reads `~/projects/`)

---

## Step 5: Config Quick-Edit Sub-Menu

**Features:**
| Entry | Action |
|-------|--------|
|  Hyprland | `nvim ~/.config/hypr/hyprland.conf` |
| 󱄅 Flake | `nvim ~/nixos/flake.nix` |
|  Keybinds | `nvim ~/.config/hypr/keybinds.conf` |
|  Aliases | `nvim ~/.config/zsh/aliases.zsh` (or equivalent) |
|  Kitty | `nvim ~/.config/kitty/kitty.conf` |
| ← Back | Return to main |

**Pattern:**
```bash
edit_config() {
    kitty --title "Edit: $1" -e nvim "$2"
}
```

**Deliverables:**
- [ ] `config_menu()` function
- [ ] Configurable file list (easy to extend)

---

## Step 6: Utils Sub-Menu

**Features:**
| Entry | Action |
|-------|--------|
| 󰹑 Screenshot Area | `grim -g "$(slurp)" - \| wl-copy` |
| 󰹑 Screenshot Full | `grim - \| wl-copy` |
| 󰹑 Screenshot Edit | Area → swappy/satty |
| 󰅍 Clipboard History | `cliphist list \| rofi -dmenu \| cliphist decode \| wl-copy` |
|  Color Picker | `hyprpicker -a` + notify |
|  Calculator | `rofi -show calc` or `qalculate-gtk` |
| ← Back | Return to main |

**Deliverables:**
- [ ] `utils_menu()` function
- [ ] cliphist setup in Nix (package + exec-once)
- [ ] Color picker with notification

---

## Step 7: Media Sub-Menu

**Features:**
| Entry | Action |
|-------|--------|
| 󰎈 Now Playing | (non-selectable header showing current track) |
| 󰒮 Previous | `playerctl previous` |
| 󰐎 Play/Pause | `playerctl play-pause` |
| 󰒭 Next | `playerctl next` |
|  Open Spotify | `spotify` |
| ← Back | Return to main |

**Now Playing Logic:**
```bash
now_playing=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null || echo "Nothing playing")
```

**Deliverables:**
- [ ] `media_menu()` function
- [ ] Dynamic "Now Playing" header

---

## Step 8: Styles Sub-Menu

**Features:**
| Entry | Action |
|-------|--------|
| 󰔎 Catppuccin Mocha | `theme catppuccin-mocha` |
| 󰖔 Catppuccin Latte | `theme catppuccin-latte-minimal` |
| 󰌪 Everforest | `theme everforest` |
| 󰒲 Cycle Theme | `theme` (no args = cycle) |
| ← Back | Return to main |

**Note:** Uses existing `~/.local/bin/theme` script.

**Deliverables:**
- [ ] `styles_menu()` function
- [ ] Dynamic theme list (read available themes from directory)

---

## Step 9: Nix Module & Keybind

**Package the script:**
```nix
# home/modules/everything-menu.nix
{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "everything-menu" (builtins.readFile ../scripts/everything-menu.sh))
  ];
}
```

**Add keybind:**
```conf
# In keybinds.conf or keybinds.nix
bind = $mainMod, D, exec, everything-menu
```

**Deliverables:**
- [ ] Nix module for the script
- [ ] Keybind configuration
- [ ] Required packages (cliphist, etc.)

---

## Implementation Order

| Phase | Steps | Complexity |
|-------|-------|------------|
| **Phase 1** | Step 1 (Core) + Step 2 (Sudo) | Foundation |
| **Phase 2** | Step 3 (System) + Step 4 (Dev/Sync) | High value |
| **Phase 3** | Step 5 (Config) + Step 6 (Utils) | Medium |
| **Phase 4** | Step 7 (Media) + Step 8 (Styles) | Polish |
| **Phase 5** | Step 9 (Nix integration) | Final |

---

## Required Packages (Add to Nix)

```nix
home.packages = with pkgs; [
  rofi-wayland      # Already have
  cliphist          # NEW - clipboard history
  hyprpicker        # Already have
  playerctl         # Already have
  libnotify         # For notify-send
  grim              # Already have
  slurp             # Already have
  swappy            # Optional - screenshot editor
];
```

**Exec-once for cliphist:**
```conf
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
```

---

## Testing Checklist

- [ ] Main menu opens with `Super+D`
- [ ] Back button returns to parent menu
- [ ] Escape closes menu entirely
- [ ] Git sync detects conflicts correctly
- [ ] Nix rebuild runs without password prompt
- [ ] Clipboard history shows recent copies
- [ ] Color picker copies hex and notifies
- [ ] Theme switch updates all apps
- [ ] Media controls work with Spotify

---

## Future Enhancements (Backlog)

- [ ] State persistence (remember last sub-menu)
- [ ] SSH host picker (parse `~/.ssh/config`)
- [ ] Docker container management
- [ ] Focus mode (pause notifications + hide bar)
- [ ] Wallpaper preview on hover
