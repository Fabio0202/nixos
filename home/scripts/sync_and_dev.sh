#!/usr/bin/env zsh

set -euo pipefail

# Check that path and branch are provided
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 /absolute/path/to/project/on/laptop branch-name" >&2
  exit 1
fi

local laptop_project_root="$1"
local laptop_branch="$2"
local laptop_ip="simon-laptop"  # Customize if needed

# Validate path
if [[ "$laptop_project_root" != /* ]]; then
  echo "Error: Path must be absolute." >&2
  exit 1
fi

# Derive equivalent path on PC
local relative_path="${laptop_project_root/#$HOME/}"
local pc_project_root="$HOME$relative_path"

mkdir -p "$pc_project_root" || {
  echo "Error: Could not create $pc_project_root" >&2
  exit 1
}

cd "$pc_project_root" || {
  echo "Error: Could not cd into $pc_project_root!" >&2
  exit 1
}

# Initialize Git if missing
if [[ ! -d ".git" ]]; then
  git init
  local remote_url=$(ssh "$laptop_ip" "git -C \"$laptop_project_root\" remote get-url origin") || {
    echo "Error: Could not get remote URL" >&2
    exit 1
  }
  git remote add origin "$remote_url"
  git fetch origin
fi

# Auto-stash local changes
if [[ -n "$(git status --porcelain)" ]]; then
  git stash push -m "Auto-stash for sync $(date)" || true
fi

# Sync the provided branch
git checkout "$laptop_branch" 2>/dev/null || git checkout -b "$laptop_branch"
git pull --rebase origin "$laptop_branch" || {
  echo "Warning: Pull/rebase failed (maybe no upstream yet?)" >&2
}

# Run via nix-shell if applicable
if [[ -f shell.nix || -f default.nix ]]; then
  echo "🔧 Detected Nix project - launching in nix-shell..."
  exec nix-shell --run "yarn install && yarn dev --hostname 0.0.0.0"
else
  yarn install && yarn dev --hostname 0.0.0.0
fi
