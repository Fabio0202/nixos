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
  # Keep the terminal's key protocol vanilla (no modifyOtherKeys/kitty CSI-u
  # reporting). With it enabled, foot can deliver C-c to child programs as an
  # escape sequence instead of ^C, so SIGINT never fires (e.g. in fzf/zoxide).
  [[ ${BLE_VERSION:-} ]] && bleopt term_modifyOtherKeys_internal=0 \
                             term_modifyOtherKeys_external=0
fi