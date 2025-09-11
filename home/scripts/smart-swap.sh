
#!/usr/bin/env bash
# smart-swap.sh

# Get active window address
addr=$(hyprctl activewindow -j | jq -r '.address')
[ -z "$addr" ] && exit 1

# Get window geometry
read x y w h <<<$(hyprctl -j clients | jq -r ".[] | select(.address==\"$addr\") | \"\(.at[0]) \(.at[1]) \(.size[0]) \(.size[1])\"")

# Get monitor height
mon_height=$(hyprctl -j monitors | jq -r ".[] | select(.id==0) | .height")

# Decide: if the window’s center is below mid-screen → swap up, else swap down
center_y=$(( y + h / 2 ))
if [ "$center_y" -gt $(( mon_height / 2 )) ]; then
  hyprctl dispatch swapwindow u
else
  hyprctl dispatch swapwindow d
fi

