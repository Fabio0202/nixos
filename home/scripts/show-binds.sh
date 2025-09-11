#!/usr/bin/env bash
JSON_FILE="$HOME/.show-binds/keybinds.json"
THEME="$HOME/.config/rofi/catppuccin-mocha.rasi"

icon_for_category() {
  case "$1" in
    Audio) echo "" ;;
    Window) echo "" ;;
    System) echo "" ;;
    Workspace) echo "" ;;
    Apps) echo "" ;;
    *) echo "" ;; # default/other
  esac
}

if [[ -z "$1" ]]; then
  # Step 1: choose category with icon
  CATEGORY=$(
    { echo "All"; jq -r '.[].category' "$JSON_FILE" | sort -u; } \
    | while read -r cat; do
        echo "$(icon_for_category "$cat") $cat"
      done \
    | rofi -dmenu -i -p "Choose category" -theme "$THEME"
  )

  [[ -z "$CATEGORY" ]] && exit 0
  CATEGORY=$(echo "$CATEGORY" | awk '{print $2}') # strip icon
  exec "$0" "$CATEGORY"
else
  if [[ "$1" == "All" ]]; then
    CHOICE=$(jq -r '.[] | "\(.keys) → \(.description) [\(.category)]\u0001\(.command)"' "$JSON_FILE" \
      | while IFS= read -r line; do
          cat=$(echo "$line" | sed -E 's/.*\[(.+)\)]\x01.*/\1/')
          icon=$(icon_for_category "$cat")
          # Pretty display before delimiter
          echo "$line" | sed -E "s/\[(.+)\)]/\[$icon \1\]/"
        done \
      | rofi -dmenu -i -p "All" -theme "$THEME")
  else
    CHOICE=$(jq -r --arg cat "$1" '.[] | select(.category==$cat) | "\(.keys) → \(.description)\u0001\(.command)"' "$JSON_FILE" \
      | rofi -dmenu -i -p "$1" -theme "$THEME")
  fi

  # Extract the hidden command (after delimiter \u0001)
  CMD=$(echo "$CHOICE" | awk -F'\x01' '{print $2}')
  [[ -n "$CMD" ]] && sh -c "$CMD"
fi
