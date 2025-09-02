#!/usr/bin/env bash

# Warning levels
LOW_BATTERY=20
CRITICAL_BATTERY=7
NOTIFICATION_SENT=false

while true; do
    # Get the battery percentage
    BATTERY_LEVEL=$(upower -i $(upower -e | grep battery) | grep percentage | awk '{print $2}' | sed 's/%//')
    BATTERY_STATE=$(upower -i $(upower -e | grep battery) | grep state | awk '{print $2}')

    if [[ "$BATTERY_STATE" == "discharging" ]]; then
        if [[ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY" ]]; then
            if [[ "$NOTIFICATION_SENT" == false ]]; then
                notify-send -u critical "Battery Critical" "Battery is at ${BATTERY_LEVEL}%. Please plug in the charger."
                NOTIFICATION_SENT=true
            fi
            while [[ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY" ]]; do
                mpv --ao=alsa ../../files/life-support.mp3
                sleep 3  # Repeat sound every 5 seconds
                # Re-check battery level and state
                BATTERY_LEVEL=$(upower -i $(upower -e | grep battery) | grep percentage | awk '{print $2}' | sed 's/%//')
                BATTERY_STATE=$(upower -i $(upower -e | grep battery) | grep state | awk '{print $2}')
                if [[ "$BATTERY_STATE" != "discharging" ]]; then
                    NOTIFICATION_SENT=false  # Reset notification for next discharging session
                    break
                fi
            done
        elif [[ "$BATTERY_LEVEL" -le "$LOW_BATTERY" ]]; then
            notify-send -u normal "Low Battery" "Battery is at ${BATTERY_LEVEL}%. Consider plugging in the charger."
                mpv --ao=alsa ../../files/pop.mp3
            NOTIFICATION_SENT=false  # Reset notification if level improves to low
            sleep 60  # Check again in 1 minute
        else
            NOTIFICATION_SENT=false  # Reset notification for normal battery level
        fi
    else
        NOTIFICATION_SENT=false  # Reset notification if battery is not discharging
    fi

    sleep 30  # Check battery status every 30 seconds
done
