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
  CATEGORY=$(echo "$CATEGORY" | cut -d' ' -f2-) # strip icon
  exec "$0" "$CATEGORY"
else
  if [[ "$1" == "All" ]]; then
    jq -r '.[] | "\(.keys) → \(.description)\t\t\t" + (.[ "command" ]) + "    [" + .category + "]"' "$JSON_FILE" \
      | while IFS=$'\t' read -r line; do
          cat=$(echo "$line" | sed -E 's/.*\[(.+)\]$/\1/')
          icon=$(icon_for_category "$cat")
          echo "$line" | sed -E "s/\[(.+)\]$/[ $icon \1]/"
        done \
      | rofi -dmenu -i -p "All" -theme "$THEME"
  else
    jq -r --arg cat "$1" '.[] | select(.category==$cat) | "\(.keys) → \(.description)\t\t\t" + (.[ "command" ])' "$JSON_FILE" \
      | rofi -dmenu -i -p "$1" -theme "$THEME"
  fi
fi
