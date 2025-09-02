#!/usr/bin/env bash

# CONFIG="$HOME/.config/hypr/wofi/config/config"
# STYLE="$HOME/.config/hypr/wofi/src/latte/style.css"

if [[ ! $(pidof wofi) ]]; then
    wofi --conf "/home/simon/nixos-dotfiles/home/configfiles/wofi/config/config" --style "/home/simon/nixos-dotfiles/home/configfiles/wofi/src/macchiato/style.css" --show drun
else
    pkill wofi
fi
