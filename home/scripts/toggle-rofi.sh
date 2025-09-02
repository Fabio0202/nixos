
#!/bin/bash

# Check if Rofi is already running
if pgrep -x "rofi" > /dev/null
then
    # Close Rofi if it's running
    pkill -x rofi
else
    # Launch Rofi if it's not running
    rofi -show combi -combi-modi "window,drun" -modi combi
fi
