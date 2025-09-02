    if pgrep -x "wlr-which-key" > /dev/null; then
      pkill -x wlr-which-key
    else
      wlr-which-key
    fi
