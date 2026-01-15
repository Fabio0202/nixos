# Task B — Move Zsh + P10k Config to Stow

## Objective
Move shell configuration responsibilities out of Home Manager and into Stow-managed dotfiles.

## Workflow
- Before starting: `notify-send "dotfiles migration" "START Task B (zsh+p10k)"`
- When done: `notify-send "dotfiles migration" "DONE Task B (zsh+p10k)"`

## Inputs
- HM module: `home/modules/sh.nix`
- P10k config source: `home/modules/p10k-config/p10k.zsh`
- Existing aliases file: `dotfiles/zsh/.zsh/aliases.zsh`

## Expected outputs
1) Add Stow-managed p10k config:
- Create `dotfiles/zsh/.p10k.zsh` with the content of `home/modules/p10k-config/p10k.zsh`.

2) Add a minimal, explicit zsh entrypoint:
- Create `dotfiles/zsh/.zshrc` that covers what HM previously injected, at minimum:
  - `source ~/.p10k.zsh`
  - `source ~/.zsh/aliases.zsh`
  - PATH additions for `~/.local/bin` and `~/.npm-global/bin`
  - the `fzf()` wrapper function from `home/modules/sh.nix` (optional if desired)
  - the `y()` function wrapper from `home/modules/sh.nix`

3) Decide how to handle HM zsh enablement
- This task should NOT fully remove packages.
- It should prepare the stow side so Task D can safely delete HM’s file-writing/zsh-init bits.

## Notes
- Avoid relying on Home Manager for `programs.zsh.initExtra*` once this is in place.
- If you still want zoxide/direnv hooks, put them in `.zshrc` (since HM won’t manage them after trimming).

## Do not change
- Do not touch `flake.nix`.
- Do not move package installs out of HM.
