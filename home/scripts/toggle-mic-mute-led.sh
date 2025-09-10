
#!/usr/bin/env bash

# Try to detect a micmute LED device
led=$(ls /sys/class/leds/*micmute*/brightness 2>/dev/null | head -n 1)

# If no LED found, exit silently
[ -z "$led" ] && exit 0

# Get PipeWire source mute state
state=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)

if [[ "$state" == *"[MUTED]"* ]]; then
  echo 1 | tee "$led"
else
  echo 0 | tee "$led"
fi
