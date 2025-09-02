
#!/usr/bin/env zsh

set -euo pipefail

# === Settings ===
remote_host="simon-pc"
remote_script="/home/simon/nixos-dotfiles/home/scripts/sync_and_dev.sh"

# === Git checks ===

# Make sure we are in a git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "❌ Not in a Git repository." >&2
  exit 1
fi

# Get branch name
branch=$(git branch --show-current)

if [[ -z "$branch" ]]; then
  echo "❌ Could not determine current branch." >&2
  exit 1
fi

# Check for uncommitted changes (staged or unstaged)
if [[ -n "$(git status --porcelain)" ]]; then
  echo "❌ You have uncommitted changes. Please stash or commit before syncing." >&2
  exit 1
fi

# Check if local branch is in sync with origin
local_hash=$(git rev-parse "$branch")
remote_hash=$(git rev-parse "origin/$branch" 2>/dev/null || echo "")

if [[ -z "$remote_hash" ]]; then
  echo "❌ Remote branch 'origin/$branch' not found." >&2
  exit 1
fi

if [[ "$local_hash" != "$remote_hash" ]]; then
  echo "❌ Local branch '$branch' is not in sync with 'origin/$branch'." >&2
  exit 1
fi

# === Sync ===

project_path="$PWD"

echo "🚀 Syncing '$project_path' on branch '$branch' to $remote_host..."

ssh "$remote_host" "$remote_script \"$project_path\" \"$branch\""
