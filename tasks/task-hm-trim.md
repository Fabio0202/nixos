# Task D — Trim Home Manager Modules (keep packages, drop dotfiles)

## Objective
Keep Home Manager for package installation, but remove dotfile generation so Stow becomes the single source of truth for config files.

## Workflow
- Before starting: `notify-send "dotfiles migration" "START Task D (HM trim)"`
- When done: `notify-send "dotfiles migration" "DONE Task D (HM trim)"`

Note: The repo policy forbids running `git`/`jj` commands.

## Inputs
- `home/modules/wrapScripts.nix` (to retire)
- `home/modules/scripts.nix` (currently writes into `~/scripts/*`)
- `home/modules/sh.nix` (currently manages zsh + writes `~/.p10k.zsh`)
- `home/modules/hyprland/hypridle.nix` and `home/modules/hyprland/hyprlock.nix`

## Expected outputs
1) Retire wrapScripts
- Stop importing/using `home/modules/wrapScripts.nix`.
- Ensure nothing depends on it for providing script commands.

2) Stop HM from writing dotfiles
Remove/disable HM sections that write:
- `home.file` entries (scripts, p10k)
- `xdg.configFile` entries for hyprlock
- `home.file` entry for hypridle

3) Keep HM packages
- Keep `home.packages` blocks needed to install the binaries.

## Notes
- Scripts should now come from stow (`~/.local/bin/*`).
- Zsh config should now come from stow (`dotfiles/zsh/.zshrc`, `dotfiles/zsh/.p10k.zsh`).

## Do not change
- Keep `systemd.user.*` definitions as-is (user chose to keep them in HM).
- Do not remove Home Manager from `flake.nix` (out of scope).
