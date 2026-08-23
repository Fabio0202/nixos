# ble.sh: fish-style autosuggestions (gray ghost text) + syntax highlighting.
# Sourced from ~/.bashrc. C-F (or Right arrow) accepts the suggestion.
# Arch: AUR package "blesh". Debian: ~/.local/share/blesh (via debian-install.sh).
if [[ $- == *i* ]]; then
  if [[ -r /usr/share/blesh/ble.sh ]]; then
    source /usr/share/blesh/ble.sh --noattach
  elif [[ -r "$HOME/.local/share/blesh/ble.sh" ]]; then
    source "$HOME/.local/share/blesh/ble.sh" --noattach
  fi
  [[ ${BLE_VERSION:-} ]] && ble-attach
fi