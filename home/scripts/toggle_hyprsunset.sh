WARM_TEMP=4000  # Define the warm temperature in Kelvin
if pgrep -x hyprsunset > /dev/null; then
  echo "[Toggle] hyprsunset is running, killing it (reset to neutral)"
  pkill hyprsunset
else
  echo "[Toggle] hyprsunset is not running, starting warm mode"
  hyprsunset -t "$WARM_TEMP" &
fi
