#!/usr/bin/env bash

NIXOS_DIR="${NIXOS_FLAKE_DIR:-$HOME/nixos}"

[[ -d "$NIXOS_DIR/.git" ]] || exit 0

# Fetch via jj to keep its op log clean
timeout 10 jj -R "$NIXOS_DIR" git fetch --quiet 2>/dev/null

# Compare @ (working copy) against master@origin — not the master bookmark
# This means you never need to manually advance master; @ is always the source of truth
ahead=$(jj -R "$NIXOS_DIR" log -r "present(master@origin)..@" --no-graph -T 'commit_id.short() ++ "\n"' 2>/dev/null | grep -c .)
behind=$(jj -R "$NIXOS_DIR" log -r "@..present(master@origin)" --no-graph -T 'commit_id.short() ++ "\n"' 2>/dev/null | grep -c .)

[[ "$ahead" -eq 0 && "$behind" -eq 0 ]] && exit 0

if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
  echo "{\"text\": \"󰓠 ${ahead}↑${behind}↓\", \"tooltip\": \"nixos: diverged — $ahead ahead, $behind behind\", \"class\": \"diverged\"}"
elif [[ "$ahead" -gt 0 ]]; then
  echo "{\"text\": \"󰛃 $ahead\", \"tooltip\": \"nixos: $ahead commit(s) ahead — click to push\", \"class\": \"ahead\"}"
else
  echo "{\"text\": \"󰜛 $behind\", \"tooltip\": \"nixos: $behind commit(s) behind — click to pull & rebuild\", \"class\": \"behind\"}"
fi
