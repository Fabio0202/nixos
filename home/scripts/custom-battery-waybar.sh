#!/usr/bin/env bash

battery_device=$(upower -e | grep BAT0 || upower -e | grep battery | head -n1)

if [[ -z "$battery_device" ]]; then
  echo '{"text": " ?", "class": "unknown", "tooltip": "No battery detected"}'
  exit 0
fi

battery=$(upower -i "$battery_device")
level=$(echo "$battery" | awk '/percentage/ {print $2}' | tr -d '%')
state=$(echo "$battery" | awk '/state/ {print $2}')
capacity="${level}%"

# Pick icon
if [[ "$state" == "charging" || "$state" == "fully-charged" ]]; then
  icon="󰂄"
else
  if   (( level < 10 )); then icon="󰁺"
  elif (( level < 20 )); then icon="󰁻"
  elif (( level < 30 )); then icon="󰁼"
  elif (( level < 40 )); then icon="󰁽"
  elif (( level < 50 )); then icon="󰁿"
  elif (( level < 60 )); then icon="󰂀"
  elif (( level < 70 )); then icon="󰂁"
  elif (( level < 80 )); then icon="󰂂"
  elif (( level < 90 )); then icon="󱟢"
  else                       icon="󰁿"
  fi
fi

# Decide class for Waybar
class=""
if   (( level <= 15 )); then class="critical"
elif (( level <= 30 )); then class="warning"
fi

# Output JSON
echo "{\"text\": \"$icon $capacity\", \"class\": \"$class\", \"tooltip\": \"$state ($capacity)\"}"
