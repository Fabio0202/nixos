#!/usr/bin/env bash

WARM_TEMP=3000
STATUS_FILE="/tmp/nightmode-status"

if [[ "$1" == "--status" ]]; then
  # Only report current state
  if pgrep -x hyprsunset >/dev/null; then
    echo ""
  else
    echo "󰖨"
  fi
  exit 0
fi

# Toggle logic
if pgrep -x hyprsunset >/dev/null; then
  pkill hyprsunset
  echo "󰖨" | tee "$STATUS_FILE"
else
  hyprsunset -t "$WARM_TEMP" &
  echo "" | tee "$STATUS_FILE"
fi
