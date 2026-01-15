# Task A — Move Scripts to Stow (retire wrapScripts)

## Objective
Move the existing scripts from `home/scripts/*.sh` into Stow-managed `~/.local/bin/*` (no `.sh` suffix) and make them executable.

## Workflow
- Before starting: `notify-send "dotfiles migration" "START Task A (scripts)"`
- When done: `notify-send "dotfiles migration" "DONE Task A (scripts)"`

This enables retiring `home/modules/wrapScripts.nix` (handled in Task D).

## Inputs
- Source scripts: `home/scripts/*.sh`
  - `battery-monitor.sh`
  - `custom-battery-waybar.sh`
  - `idle_status.sh`
  - `minimize.sh`
  - `smart-swap.sh`
  - `sync_and_dev.sh`
  - `toggle-waybar.sh`
  - `toggle-wk.sh`
  - `toggle_hyprsunset.sh`
  - `toggle_idle.sh`
  - `toggle-mic-mute-led.sh`
  - `toggle-rofi.sh`

## Expected outputs
Create equivalents under:
- `dotfiles/stow-common/.local/bin/<name>`

Mapping rule:
- `home/scripts/foo-bar.sh` → `dotfiles/stow-common/.local/bin/foo-bar`

## Notes
- Preserve shebangs.
- Ensure executable mode on all created stow scripts.
- If any scripts refer to repo-relative paths like `~/nixos/home/scripts/...`, adjust them to use either:
  - `~/.local/bin/...` (preferred), or
  - an absolute path into the repo only if unavoidable.

## Do not change
- Do not modify systemd user units in this task.
- Do not remove `wrapScripts` yet (Task D).
