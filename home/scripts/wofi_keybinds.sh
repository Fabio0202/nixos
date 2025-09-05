
#!/bin/bash

HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

# extract keybindings from hyprland.conf
mapfile -t BINDINGS < <(
  grep '^bind' "$HYPR_CONF" | \
  sed -e 's/  */ /g' -e 's/bind=//g' -e 's/, /,/g' -e 's/ # /,/' | \
  awk -F, '{cmd=""; for(i=3;i<NF;i++) cmd=cmd $(i) " "; print $1 " + " $2 " → " cmd $NF}'
)

# pick one via wofi
CHOICE=$(printf '%s\n' "${BINDINGS[@]}" | wofi --dmenu --prompt "Hyprland Keybinds:")

# extract the command part after the arrow
CMD=$(echo "$CHOICE" | awk -F'→' '{print $2}' | xargs)

# execute it if it starts with exec, otherwise dispatch it
if [[ $CMD == exec* ]]; then
  eval "$CMD"
else
  hyprctl dispatch "$CMD"
fi
