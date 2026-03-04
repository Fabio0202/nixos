#!/usr/bin/env bash

NIXOS_DIR="${NIXOS_FLAKE_DIR:-$HOME/nixos}"
HOST="$(hostname)"

ahead=$(jj -R "$NIXOS_DIR" log -r "present(master@origin)..@" --no-graph -T 'commit_id.short() ++ "\n"' 2>/dev/null | grep -c .)
behind=$(jj -R "$NIXOS_DIR" log -r "@..present(master@origin)" --no-graph -T 'commit_id.short() ++ "\n"' 2>/dev/null | grep -c .)

_open_jjui() {
  ghostty --working-directory="$NIXOS_DIR" -e jjui
}

# Diverged — open jjui, too risky to automate
if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
  _open_jjui
  exit 0
fi

if [[ "$behind" -gt 0 ]]; then
  # Rebase @ onto master@origin
  # jj records conflicts inside commits rather than aborting, so this always completes
  jj -R "$NIXOS_DIR" rebase -d "master@origin" 2>/dev/null

  conflicts=$(jj -R "$NIXOS_DIR" resolve --list 2>/dev/null | grep -c .)
  if [[ "$conflicts" -gt 0 ]]; then
    _open_jjui
    exit 0
  fi

  # Fast-forward master bookmark to match origin (needed for git push to work later)
  jj -R "$NIXOS_DIR" bookmark set master -r "master@origin" 2>/dev/null

  # Rebuild in a visible terminal — you want to see if something breaks
  ghostty --working-directory="$NIXOS_DIR" -e sh -c \
    "sudo nixos-rebuild switch --flake '${NIXOS_DIR}#${HOST}' --impure; echo; echo '— rebuild done, press enter to close —'; read"

  # Move to a fresh commit on top of the updated state
  jj -R "$NIXOS_DIR" new

  pkill -RTMIN+11 waybar 2>/dev/null
  exit 0
fi

if [[ "$ahead" -gt 0 ]]; then
  # Advance master to @ then push — you never touch the bookmark manually
  jj -R "$NIXOS_DIR" bookmark set master -r @ 2>/dev/null
  result=$(jj -R "$NIXOS_DIR" git push 2>&1)
  notify-send "nixos sync" "$result"

  # Move to a fresh commit so you're not amending what's now on origin
  jj -R "$NIXOS_DIR" new

  pkill -RTMIN+11 waybar 2>/dev/null
  exit 0
fi
