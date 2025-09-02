
#!/bin/bash

# Set workspace IDs
FIREFOX_WORKSPACE="1"
NEOVIDE_WORKSPACE="2"
TERMINAL_WORKSPACE="3"
MONGODB_WORKSPACE="4"
GITKRAKEN_WORKSPACE="5"

# Links to open in Firefox
LINKS=(
    "https://fishyvisions.atlassian.net/jira/software/c/projects/WD/boards/33?assignee=712020%3A1d8a3e93-c761-4f7c-b00f-765adb53c98d&assignee=unassigned&useStoredSettings=true"
    "https://windu-development.atlassian.net/jira/software/projects/KT/apps/5bbe60e9-603d-47a2-a7b2-54e2aa6f5881/66cd8716-04ee-49f9-9587-1a59db882ca1"
    "https://app.clockify.me/tracker"
)

# Launch Firefox and move to workspace 1
firefox "${LINKS[@]}" &
sleep 2  # Allow the window to appear
FIREFOX_WINDOW=$(hyprctl clients | grep -B1 "class: firefox" | grep "Window" | awk '{print $2}')
hyprctl dispatch movetoworkspace "$FIREFOX_WORKSPACE" "$FIREFOX_WINDOW"

# Launch Neovide and move to workspace 2
neovide &
sleep 2  # Allow the window to appear
NEOVIDE_WINDOW=$(hyprctl clients | grep -B1 "class: neovide" | grep "Window" | awk '{print $2}')
hyprctl dispatch movetoworkspace "$NEOVIDE_WORKSPACE" "$NEOVIDE_WINDOW"

# Open terminal on workspace 3 and run yarn dev
kitty --working-directory "/home/simon/code/windu_rally" -e bash -c "yarn dev; exec bash" &
sleep 2  # Allow the window to appear
TERMINAL_WINDOW=$(hyprctl clients | grep -B1 "class: kitty" | grep "Window" | awk '{print $2}')
hyprctl dispatch movetoworkspace "$TERMINAL_WORKSPACE" "$TERMINAL_WINDOW"

# Open MongoDB Compass on workspace 4
mongodb-compass &
sleep 2  # Allow the window to appear
MONGODB_WINDOW=$(hyprctl clients | grep -B1 "class: mongodb-compass" | grep "Window" | awk '{print $2}')
hyprctl dispatch movetoworkspace "$MONGODB_WORKSPACE" "$MONGODB_WINDOW"

# Open GitKraken on workspace 5
gitkraken &
sleep 2  # Allow the window to appear
GITKRAKEN_WINDOW=$(hyprctl clients | grep -B1 "class: gitkraken" | grep "Window" | awk '{print $2}')
hyprctl dispatch movetoworkspace "$GITKRAKEN_WORKSPACE" "$GITKRAKEN_WINDOW"

echo "Work environment setup complete!"
