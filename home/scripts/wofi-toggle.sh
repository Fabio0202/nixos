#!/usr/bin/env bash

CONFIG="$HOME/.config/wofi/config/config"
STYLE="$HOME/.config/wofi/src/macchiato/style.css"

if ! pgrep -x wofi >/dev/null; then
    wofi --conf "$CONFIG" --style "$STYLE" --show drun
else
    pkill wofi
fi
