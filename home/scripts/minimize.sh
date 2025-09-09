
#!/usr/bin/env bash

# Where to keep track of minimized windows
STATE="$XDG_RUNTIME_DIR/hyprland-minimized"

ADDR=$(hyprctl activewindow -j | jq -r '.address')
TITLE=$(hyprctl activewindow -j | jq -r '.title')

if [ -n "$ADDR" ]; then
  # Move it to a hidden workspace
  hyprctl dispatch movetoworkspacesilent special:minimized,address:$ADDR
  # Save info so we can restore later
  echo -e "$ADDR\t$TITLE" >> "$STATE"
fi
