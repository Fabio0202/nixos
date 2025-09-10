#!/usr/bin/env bash

battery=$(upower -i "$(upower -e | grep battery)")
level=$(echo "$battery" | awk '/percentage/ {print $2}' | tr -d '%')
capacity="${level}%"
state=$(echo "$battery" | awk '/state/ {print $2}')

# Pick icon
if [[ "$state" == "charging" || "$state" == "fully-charged" ]]; then
  icon="󰂄"
else
  if   (( level < 15 )); then icon="󰂎"
  elif (( level < 30 )); then icon="󰁻"
  elif (( level < 50 )); then icon="󰁼"
  elif (( level < 70 )); then icon="󰁽"
  elif (( level < 90 )); then icon="󰁾"
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
