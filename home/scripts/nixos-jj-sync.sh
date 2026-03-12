#!/usr/bin/env bash

NIXOS_DIR="${NIXOS_FLAKE_DIR:-$HOME/nixos}"
HOST="$(hostname)"

# Show loading state in waybar immediately
echo '{"text": "󱍸 …", "tooltip": "syncing…", "class": "syncing"}' > /tmp/nixos-sync-override
pkill -RTMIN+11 waybar 2>/dev/null

_cleanup() {
  rm -f /tmp/nixos-sync-override
  pkill -RTMIN+11 waybar 2>/dev/null
}
trap _cleanup EXIT

ahead=$(jj -R "$NIXOS_DIR" log -r "(present(master@origin)..@) ~ empty()" --no-graph -T 'commit_id.short() ++ "\n"' 2>/dev/null | grep -c .)
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
  # @ is already sitting on top of the rebased state — no jj new needed

  exit 0
fi

if [[ "$ahead" -gt 0 ]]; then
  # Point master at the last non-empty commit — not @ itself, which may be an empty working copy
  last_nonempty=$(jj -R "$NIXOS_DIR" log -r "latest((present(master@origin)..@) ~ empty())" --no-graph -T 'commit_id.short()' 2>/dev/null)
  jj -R "$NIXOS_DIR" bookmark set master -r "$last_nonempty" 2>/dev/null
  jj -R "$NIXOS_DIR" git push 2>/dev/null
  # jj auto-creates a new @ after push since pushed commits become immutable — no jj new needed

  exit 0
fi
