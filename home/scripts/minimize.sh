#!/usr/bin/env bash
STATE="$XDG_RUNTIME_DIR/hyprland-minimized"

ADDR=$(hyprctl activewindow -j | jq -r '.address')
TITLE=$(hyprctl activewindow -j | jq -r '.title')

[ -z "$ADDR" ] && exit 0
touch "$STATE"

# Avoid duplicate entries for the same window address
awk -F'\t' -v addr="$ADDR" '$1 == addr {found=1} END{exit found?0:1}' "$STATE"
if [ $? -ne 0 ]; then
  printf '%s\t%s\n' "$ADDR" "$TITLE" >> "$STATE"
fi

# Move to special workspace
hyprctl dispatch movetoworkspacesilent special:minimized,address:$ADDR
