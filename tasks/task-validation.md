# Task F — Validation

## Objective
Run quick validation steps to ensure the migration didn’t break evaluation.

## Workflow
- Before starting: `notify-send "dotfiles migration" "START Task F (validation)"`
- When done: `notify-send "dotfiles migration" "DONE Task F (validation)"`

## Commands
- `nix flake check`

## Manual sanity checks (no switching)
- Confirm stow tree contains:
  - `dotfiles/stow-common/.local/bin/*`
  - `dotfiles/stow-common/.config/hypr/hyprlock.conf`
  - `dotfiles/stow-common/.config/hypr/hypridle.conf`
  - `dotfiles/zsh/.zshrc`
  - `dotfiles/zsh/.p10k.zsh`

## Notes
- Do not run `nixos-rebuild switch`.
- If any HM evaluation fails due to removed options, fix by keeping only package-related HM config.
