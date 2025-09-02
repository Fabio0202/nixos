#!/usr/bin/env bash

LOCK_FILE="/tmp/waybar.lock"
LOG_FILE="$HOME/.cache/waybar.log"

# Acquire lock
for ((i=0; i<10; i++)); do
    if ! mkdir "$LOCK_FILE" 2>/dev/null; then
        sleep 1
    else
        break
    fi
done

if ! [ -d "$LOCK_FILE" ]; then
    echo "Could not acquire lock. Exiting." >&2
    exit 1
fi

trap 'rm -rf "$LOCK_FILE"' EXIT

# Kill existing Waybar
pkill -x "waybar" || true

# Start Waybar (silence logs or redirect to file)
waybar -c ~/.config/waybar/config.json --log-level=error &> "$LOG_FILE" &

# Verify startup
sleep 3
if ! pgrep -x "waybar" >/dev/null; then
    echo "Waybar failed to start!" >&2
    exit 1
fi

echo "Waybar started (logs at $LOG_FILE)."
exit 0
