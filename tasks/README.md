# Parallel Migration Tasks (Home Manager → Stow for dotfiles)

Goal: **keep Home Manager for package installs**, but move **dotfiles/config files/scripts** to **GNU Stow**, and **retire** `home/modules/wrapScripts.nix`.

## Global constraints
- Do **not** run `git`/`jj` commands.
- Do **not** run `nixos-rebuild switch` or `home-manager switch`.
- Prefer minimal, surgical changes.

## Agent workflow (start/end signals)
Before starting any task:
- Send a desktop notification: `notify-send "dotfiles migration" "START <task-id>"`

When done with the task:
- Send a desktop notification: `notify-send "dotfiles migration" "DONE <task-id>"`

Note: The repo policy forbids `git`/`jj`, so tasks should not create branches/commits.

## Target end-state (high level)
- Scripts live in `dotfiles/stow-common/.local/bin/*` (no `.sh` suffix) and are executable.
- Hypr configs (hyprlock, hypridle) live in `dotfiles/stow-common/.config/hypr/`.
- Zsh + p10k live in `dotfiles/zsh/` and are sourced by a stowed `~/.zshrc`.
- Home Manager still installs packages, but no longer writes these dotfiles.

## Work splitting
Run these tasks in parallel (A-D), then do E-F after merge.

- A: `task-scripts.md` — move scripts to stow + ensure executables
- B: `task-zsh-p10k.md` — move zsh config + p10k to stow (replace HM-managed zsh)
- C: `task-hyprlock-hypridle.md` — move hyprlock/hypridle configs to stow
- D: `task-hm-trim.md` — retire `wrapScripts` and remove HM file-writing bits
- E: `task-hypr-keybinds.md` — update hypr keybind references if needed
- F: `task-validation.md` — run checks + sanity steps
