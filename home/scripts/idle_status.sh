FLAG="/tmp/disable-idle"

if [ -f "$FLAG" ]; then
  echo '{"text": "", "tooltip": "Idle disabled", "class": "idle-off"}'
else
  echo '{"text": "󰤄", "tooltip": "Idle enabled", "class": "idle-on"}'
fi
