# Hyprland Sleep Crash Investigation

## Primary Issue
Configuration mismatch between hypridle module imports causing crashes during sleep mode.

## Root Cause
- `hypridle` runs via `exec-once` in `hyprland.conf:24`
- But `hypridle.nix` import is commented out in `default.nix:19`
- Results in misconfigured hypridle crashing on sleep/resume events

## Key Files to Examine
- `/home/simon/nixos/home/modules/hyprland/default.nix` (line 19)
- `/home/simon/nixos/home/modules/hyprland/hypridle.nix`
- `/home/simon/nixos/.config/hypr/hyprland.conf` (line 24)

## Fix Required
1. Uncomment hypridle import in `default.nix:19`
2. Add delay to `after_sleep_cmd` in hypridle config
3. Verify proper configuration file generation

## Contributing Factors
- DPMS commands executing too early on resume
- AMD GPU suspend/resume mitigations already in place
- Potential power management conflicts