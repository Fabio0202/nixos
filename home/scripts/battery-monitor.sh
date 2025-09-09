#!/usr/bin/env bash

LOW=15
CRITICAL=7

SOUND_DIR="$HOME/nixos/files"
CRITICAL_SOUND="$SOUND_DIR/life-support.mp3"
LOW_SOUND="$SOUND_DIR/pop.mp3"

last_level=100
last_state=""
critical_notified=false

while true; do
  battery_info=$(upower -i "$(upower -e | grep battery)")
  level=$(echo "$battery_info" | awk '/percentage/ {print $2}' | tr -d '%')
  state=$(echo "$battery_info" | awk '/state/ {print $2}')

  if [[ "$state" == "discharging" ]]; then
    if (( level <= CRITICAL )); then
      if ! $critical_notified; then
        notify-send -u critical "Battery Critical" "Battery at ${level}%. Plug in now!"
        critical_notified=true
      fi
      mpv --really-quiet --no-video "$CRITICAL_SOUND" &
      sleep 10   # spam sound every 10s while critical
      continue   # skip the normal sleep below
    elif (( level <= LOW )); then
      if (( last_level > LOW )) || [[ "$last_state" != "discharging" ]]; then
        notify-send -u normal "Low Battery" "Battery at ${level}%."
        mpv --really-quiet --no-video "$LOW_SOUND" &
      fi
      critical_notified=false
    else
      critical_notified=false
    fi
  else
    critical_notified=false
  fi

  last_level=$level
  last_state=$state

  sleep 60  # normal interval when not critical
done
