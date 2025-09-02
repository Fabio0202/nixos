FLAG="/tmp/disable-idle"

if [ -f "$FLAG" ]; then
  rm "$FLAG"
  notify-send "Idle Enabled"
else
  touch "$FLAG"
  notify-send "Idle Disabled"
fi
