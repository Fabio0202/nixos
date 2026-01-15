# Task C — Move Hyprlock + Hypridle Configs to Stow

## Objective
Home Manager currently generates hyprlock/hypridle configs. Move these config files into Stow so the Hyprland setup is fully file-based.

## Workflow
- Before starting: `notify-send "dotfiles migration" "START Task C (hyprlock+hypridle)"`
- When done: `notify-send "dotfiles migration" "DONE Task C (hyprlock+hypridle)"`

## Inputs
- HM hypridle file content: `home/modules/hyprland/hypridle.nix` (writes `~/.config/hypr/hypridle.conf`)
- HM hyprlock file content: `home/modules/hyprland/hyprlock.nix` (writes `~/.config/hypr/hyprlock.conf`)

## Expected outputs
Create stow-managed files:
- `dotfiles/stow-common/.config/hypr/hypridle.conf`
- `dotfiles/stow-common/.config/hypr/hyprlock.conf`

Copy the literal contents from HM (no behavioral changes).

## Notes
- After this lands, Task D will remove the HM `home.file` / `xdg.configFile` writers.
- Make sure `hyprland-stow.conf` continues to start `hypridle` and `hyprlock` (it already does).

## Do not change
- Do not modify Hyprland plugin installation logic.
- Do not change any systemd units.
