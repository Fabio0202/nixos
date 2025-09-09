#!/usr/bin/env bash

CONFIG="/home/simon/nixos-dotfiles/home/configfiles/wofi/config/config"
STYLE="/home/simon/nixos-dotfiles/home/configfiles/wofi/src/macchiato/style.css"
STATE="$XDG_RUNTIME_DIR/hyprland-minimized"
CURRENT_WS=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.name')

if [[ $(pidof wofi) ]]; then
    pkill wofi
    exit 0
fi

[ ! -f "$STATE" ] && exit 0

CHOICE=$(cut -f2 "$STATE" | wofi --conf "$CONFIG" --style "$STYLE" --dmenu --prompt "Restore window:")

if [ -n "$CHOICE" ]; then
    ADDR=$(grep -P "\t$CHOICE$" "$STATE" | cut -f1 | head -n1)
    if [ -n "$ADDR" ]; then
        # Move window back to current workspace
        hyprctl dispatch movetoworkspacesilent name:$CURRENT_WS,address:$ADDR
        # Remove from minimized list
        grep -Pv "^$ADDR\t" "$STATE" > "$STATE.tmp" && mv "$STATE.tmp" "$STATE"
    fi
fi
