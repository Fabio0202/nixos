START_SCRIPT="$HOME/scripts/start-waybar.sh"

if pgrep -f waybar > /dev/null; then
  pkill -f waybar
else
  "$START_SCRIPT" &
fi
