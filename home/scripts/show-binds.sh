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
  # Step 1: choose category
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
    # Store commands in a temporary file or array, then use index
    CHOICE=$(
      jq -r --arg cat "$1" '.[] | "\(.keys) → \(.description) [\(.category)]\t\(.command)"' "$JSON_FILE" \
      | while IFS= read -r line; do
          cmd=$(echo "$line" | cut -d$'\t' -f2)
          display=$(echo "$line" | cut -d$'\t' -f1)
          cat=$(echo "$display" | sed -E 's/.*\[(.+)\].*/\1/')
          icon=$(icon_for_category "$cat")
          display=$(echo "$display" | sed -E "s/\[(.+)\]/[ $icon \1]/")
          echo -e "$display\t$cmd"
        done \
      | rofi -dmenu -i -p "$1" -theme "$THEME" -nullok -format s
    )
  else
    CHOICE=$(
      jq -r --arg cat "$1" '.[] | select(.category==$cat) | "\(.keys) → \(.description)\t\(.command)"' "$JSON_FILE" \
      | rofi -dmenu -i -p "$1" -theme "$THEME" -nullok -format s
    )
  fi

  # Extract command after tab delimiter
  CMD=$(echo "$CHOICE" | cut -d$'\t' -f2)
  [[ -n "$CMD" ]] && sh -c "$CMD"
fi
