#!/usr/bin/env bash

# CONFIG="$HOME/.config/hypr/wofi/config/config"
# STYLE="$HOME/.config/hypr/wofi/src/latte/style.css"

if [[ ! $(pidof wofi) ]]; then
    wofi --conf "/home/fabio/nixos/home/configfiles/wofi/config/config" --style "/home/fabio/nixos/home/configfiles/wofi/src/mocha/style.css" --show drun
else
    pkill wofi
fi
