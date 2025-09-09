#!/usr/bin/env bash

CONFIG="/home/fabio/nixos/home/configfiles/wofi/config/config"
STYLE="/home/fabio/nixos/home/configfiles/wofi/src/macchiato/style.css"
STATE="$XDG_RUNTIME_DIR/hyprland-minimized"
CURRENT_WS=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.name')

# Toggle behavior: close Wofi if it's already open
if pgrep -x wofi >/dev/null; then
  pkill wofi
  exit 0
fi

[ ! -s "$STATE" ] && exit 0

CURRENT_WS=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.name')

# Show titles to the user, but match by exact field value (no regex)
CHOICE=$(awk -F'\t' '{print $2}' "$STATE" | \
  wofi --conf "$CONFIG" --style "$STYLE" --dmenu --prompt "Restore window:")

[ -z "$CHOICE" ] && exit 0

# Find the address whose title equals CHOICE (field 2)
ADDR=$(awk -F'\t' -v choice="$CHOICE" '$2 == choice {print $1; exit}' "$STATE")
[ -z "$ADDR" ] && exit 0

# Restore to current workspace
hyprctl dispatch movetoworkspacesilent name:"$CURRENT_WS",address:$ADDR

# Remove that entry from the state file (match by address in field 1)
awk -F'\t' -v addr="$ADDR" '$1 != addr' "$STATE" > "$STATE.tmp" && mv "$STATE.tmp" "$STATE"
