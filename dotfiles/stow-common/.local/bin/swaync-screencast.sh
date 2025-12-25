#!/usr/bin/env bash
dbus-monitor --session "interface='org.freedesktop.portal.ScreenCast'" |
  while read -r line; do
    if [[ "$line" == *"method call"* && "$line" == *"Start"* ]]; then
      echo "[ScreenCast] Started → enabling DND"
      swaync-client --dnd-on
    elif [[ "$line" == *"method call"* && "$line" == *"Stop"* ]]; then
      echo "[ScreenCast] Stopped → disabling DND"
      swaync-client --dnd-off
    fi
  done
