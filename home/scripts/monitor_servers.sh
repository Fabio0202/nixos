#!/usr/bin/env bash

URLS=(
    "https://www.google.com"
    "https://example.com"
    "https://simone-muscas.com"
    "https://deframed.at"
)

LOG_FILE="$HOME/url-monitor.log"
STATE_FILE="$HOME/url-monitor-state"

# Ensure the state file exists
touch "$STATE_FILE"

# Load previous states into an associative array
declare -A STATES
while IFS= read -r line; do
  URL=$(echo "$line" | cut -d ' ' -f1)
  STATUS=$(echo "$line" | cut -d ' ' -f2)
  STATES["$URL"]="$STATUS"
done < "$STATE_FILE"

while true; do
  # Check each URL
  for URL in "${URLS[@]}"; do
    if [[ -n "$URL" ]]; then
      # Follow redirects with -L
      HTTP_STATUS=$(curl -L -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$URL")
      
      if [[ "$HTTP_STATUS" -ne 200 ]]; then
        echo "$(date): $URL is DOWN! (Status: $HTTP_STATUS)" >> "$LOG_FILE"

        if [[ "${STATES["$URL"]}" != "DOWN" ]]; then
          notify-send "URL Monitor" "Alert: $URL is DOWN! (Status: $HTTP_STATUS)"
          STATES["$URL"]="DOWN"
        fi
      else
        echo "$(date): $URL is UP. (Status: $HTTP_STATUS)" >> "$LOG_FILE"

        if [[ "${STATES["$URL"]}" == "DOWN" ]]; then
          notify-send "URL Monitor" "Good news: $URL is back UP! (Status: $HTTP_STATUS)"
          STATES["$URL"]="UP"
        fi
      fi
    fi
  done

  # Save the updated states back to the state file
  > "$STATE_FILE" # Clear the file
  for URL in "${!STATES[@]}"; do
    echo "$URL ${STATES["$URL"]}" >> "$STATE_FILE"
  done

  # Wait 5 minutes before the next check
  sleep 300
done
