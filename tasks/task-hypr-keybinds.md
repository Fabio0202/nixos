# Task E — Hypr Keybinds & Script References

## Objective
After scripts move from HM/Nix-generated wrappers to Stow-managed `~/.local/bin/*`, ensure Hyprland bindings still reference valid commands/paths.

## Workflow
- Before starting: `notify-send "dotfiles migration" "START Task E (hypr keybinds)"`
- When done: `notify-send "dotfiles migration" "DONE Task E (hypr keybinds)"`

## Inputs
- Hypr keybinds: `dotfiles/stow-common/.config/hypr/keybinds.conf`
- Any other hypr config files under `dotfiles/stow-common/.config/hypr/`

## Checklist
- Identify references like:
  - `~/nixos/home/scripts/...`
  - bare commands that used to come from `wrapScripts` (e.g. `minimize`)
- Ensure these resolve via:
  - calling `~/.local/bin/<command>` explicitly, OR
  - ensuring `~/.local/bin` is always in PATH for Hyprland sessions.

## Expected output
- A consistent approach across binds (prefer explicit `~/.local/bin/...` to avoid PATH surprises).

## Do not change
- Don’t alter keybind behavior (just fix paths).
