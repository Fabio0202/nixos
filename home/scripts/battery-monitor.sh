#!/usr/bin/env bash



# prevent multiple instances
LOCKFILE="/tmp/battery-monitor.lock"
exec 9>"$LOCKFILE"
if ! flock -n 9; then
  echo "Battery monitor already running, exiting."
  exit 1
fi

LOW=15
CRITICAL=7

SOUND_DIR="$HOME/nixos-dotfiles/files"
CRITICAL_SOUND="$SOUND_DIR/life-support.mp3"
LOW_SOUND="$SOUND_DIR/pop.mp3"

last_level=100
last_state=""
critical_notified=false
NID=0

close_notification() {
  if [[ $NID -ne 0 ]]; then
    gdbus call \
      --session \
      --dest org.freedesktop.Notifications \
      --object-path /org/freedesktop/Notifications \
      --method org.freedesktop.Notifications.CloseNotification \
      "$NID" >/dev/null 2>&1
    NID=0
  fi
}

# background watcher for charging events
upower --monitor | while read -r line; do
  if echo "$line" | grep -qi "state"; then
    state=$(upower -i "$(upower -e | grep battery)" | awk '/state/ {print $2}')
    level=$(upower -i "$(upower -e | grep battery)" | awk '/percentage/ {print $2}' | tr -d '%')

    if [[ "$state" == "charging" ]]; then
      # clear existing notifications
      close_notification
      # optional: show a fresh "charging" notice
      NID=$(notify-send -p -u low -r $NID \
        "Charging" "Charger connected. Battery at ${level}%.")
      critical_notified=false
    fi
  fi
done &

# main loop for periodic checks
while true; do
  battery_info=$(upower -i "$(upower -e | grep battery)")
  level=$(echo "$battery_info" | awk '/percentage/ {print $2}' | tr -d '%')
  state=$(echo "$battery_info" | awk '/state/ {print $2}')

  if [[ "$state" == "discharging" ]]; then
    if (( level <= CRITICAL )); then
      if ! $critical_notified; then
        NID=$(notify-send -p -u critical -r $NID \
          "Battery Critical" "Battery at ${level}%. Plug in now!")
        critical_notified=true
      else
        NID=$(notify-send -p -u critical -r $NID \
          "Battery Critical" "Battery still at ${level}%. Plug in now!")
      fi
      mpv --really-quiet --no-video "$CRITICAL_SOUND" &
      sleep 10
      continue
    elif (( level <= LOW )); then
      if (( last_level > LOW )) || [[ "$last_state" != "discharging" ]]; then
        NID=$(notify-send -p -u normal -r $NID \
          "Low Battery" "Battery at ${level}%.")
        mpv --really-quiet --no-video "$LOW_SOUND" &
      fi
      critical_notified=false
    else
      critical_notified=false
    fi
  fi

  last_level=$level
  last_state=$state

  sleep 60
done
