#!/usr/bin/env bash
# omarchy-install.sh — vanilla Omarchy -> Simon's keybinds and settings.
#
# Usage (from anywhere):
#   curl -fsSL https://raw.githubusercontent.com/Fabio0202/nixos/master/omarchy-install.sh | sh
# Or from a clone:
#   ./omarchy-install.sh
#
# Safe to re-run: every step is guarded and idempotent. Existing files that
# would conflict with the stow package are moved to a timestamped backup.
set -Eeuo pipefail

REPO_URL="https://github.com/Fabio0202/nixos.git"
BRANCH="master"
STOW_PKGS=(stow-cli stow-omarchy)
PACMAN_PKGS=(stow yazi trash-cli anki fzf zoxide eza)
AUR_PKGS=(blesh) # bash line editor: syntax highlighting + C-F autosuggestions

# Stow targets that may exist as real files and must be backed up first.
STOW_TARGETS=(
  ".config/hypr/bindings.lua"
  ".config/hypr/input.lua"
  ".config/hypr/looknfeel.lua"
  ".config/bash/aliases.bash"
  ".config/bash/ble.bash"
  ".config/bash/tools.bash"
  ".config/xremap"
  ".config/systemd/user/xremap.service"
  ".config/systemd/user/xremap-environment.service"
)

UDEV_RULE='KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"'

# ── logging ─────────────────────────────────────────────────────────────
USE_COLOR=1
[[ -t 1 ]] || USE_COLOR=0
c_info="" c_ok="" c_warn="" c_err="" c_dim="" c_off=""
if ((USE_COLOR)); then
  c_info=$'\e[1;34m'; c_ok=$'\e[1;32m'; c_warn=$'\e[1;33m'
  c_err=$'\e[1;31m'; c_dim=$'\e[2m'; c_off=$'\e[0m'
fi
info() { printf '%s[>]%s %s\n' "$c_info" "$c_off" "$*"; }
ok()   { printf '%s[ok]%s %s\n' "$c_ok" "$c_off" "$*"; }
warn() { printf '%s[!!]%s %s\n' "$c_warn" "$c_off" "$*"; }
die()  { printf '%s[xx]%s %s\n' "$c_err" "$c_off" "$*" >&2; exit 1; }

STEP="init"
on_error() {
  printf '%s[xx]%s step [%s] failed at line %s — see messages above\n' \
    "$c_err" "$c_off" "$STEP" "$1" >&2
  exit 1
}
trap 'on_error $LINENO' ERR

# Collected for the final summary.
DONE=() SKIPPED=() ACTIONS=()
NEED_RELOGIN=0

usage() {
  cat <<EOF
omarchy-install.sh — set up Simon's Omarchy keybinds and settings.

  curl -fsSL https://raw.githubusercontent.com/Fabio0202/nixos/master/omarchy-install.sh | sh

Options:
  --no-color   disable colored output
  -h, --help   show this help
EOF
}

# ── pre-flight ──────────────────────────────────────────────────────────
preflight() {
  STEP="pre-flight"
  ((EUID != 0)) || die "Do not run as root — sudo is used only where needed."
  [[ -d /usr/share/omarchy ]] || die "Omarchy not found — this script targets an Omarchy install."
  command -v pacman >/dev/null || die "pacman not found."
  command -v git >/dev/null || die "git not found."
  [[ -f "$HOME/.bashrc" ]] || die "$HOME/.bashrc not found."
  ok "pre-flight checks passed"
}

# If the script runs without its repo next to it (curl | sh), use a
# persistent managed clone at ~/.local/share/omarchy-dotfiles/nixos so the
# stow symlinks stay valid after the run. Re-running updates the clone.
self_locate() {
  STEP="locate"
  local script_dir
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
  if [[ -d "$script_dir/dotfiles/${STOW_PKGS[0]}" ]]; then
    REPO_DIR="$script_dir"
    return
  fi
  info "script was piped/downloaded — syncing managed clone"
  curl -fsI --max-time 10 https://github.com >/dev/null \
    || die "no network connection"
  local managed="$HOME/.local/share/omarchy-dotfiles/nixos"
  if [[ -d "$managed/.git" ]]; then
    git -C "$managed" fetch --depth 1 origin "$BRANCH" \
      && git -C "$managed" reset --hard FETCH_HEAD >/dev/null \
      || die "failed to update managed clone"
  else
    mkdir -p "$(dirname "$managed")"
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$managed" \
      || die "git clone failed"
  fi
  exec bash "$managed/omarchy-install.sh" "$@"
}

# ── packages ────────────────────────────────────────────────────────────
install_packages() {
  STEP="packages (official repos)"
  local missing=() p
  for p in "${PACMAN_PKGS[@]}"; do
    pacman -T "$p" >/dev/null 2>&1 || missing+=("$p")
  done
  if ((${#missing[@]})); then
    info "installing: ${missing[*]}"
    sudo pacman -S --needed --noconfirm "${missing[@]}"
  else
    SKIPPED+=("official packages already installed")
  fi
  for p in "${PACMAN_PKGS[@]}"; do
    pacman -Qq "$p" >/dev/null 2>&1 || die "package failed to install: $p"
  done
  ok "official packages ready"

  STEP="packages (AUR)"
  local a m_missing=()
  for a in "${AUR_PKGS[@]}"; do
    pacman -Qq "$a" >/dev/null 2>&1 || m_missing+=("$a")
  done
  if ((!${#m_missing[@]})); then
    SKIPPED+=("AUR packages already installed")
  elif command -v yay >/dev/null 2>&1; then
    info "installing from AUR: ${m_missing[*]}"
    if yay -S --needed --noconfirm --answerdiff None --answeredit None \
      "${m_missing[@]}"; then
      ok "AUR packages ready"
    else
      warn "AUR install failed — continuing without: ${m_missing[*]}"
      SKIPPED+=("AUR packages (failed — rerun script to retry)")
    fi
  else
    warn "yay not found — skipping AUR packages: ${AUR_PKGS[*]}"
    SKIPPED+=("AUR packages (no yay)")
  fi
}

# ── backup + stow ───────────────────────────────────────────────────────
# GNU stow keeps no database — its symlinks ARE the state. Remove links
# that point into a $STOW_PKG copy from a previous run (which may be a
# different clone) so the fresh stow below recreates them cleanly.
purge_stale_stow_links() {
  local t a real p keep_prefix
  for t in "${STOW_TARGETS[@]}"; do
    a="$HOME/$t"
    while [[ "$a" != "$HOME" && "$a" != "/" ]]; do
      if [[ -L "$a" ]]; then
        # readlink -m (not -f): resolves dangling links too, so links into
        # a deleted clone still get recognized and purged.
        real="$(readlink -m "$a")"
        local keep=0 foreign=0
        for p in "${STOW_PKGS[@]}"; do
          [[ "$real" == "$REPO_DIR/dotfiles/$p"* ]] && keep=1
          [[ "$real" == */dotfiles/$p/* ]] && foreign=1
        done
        if ((keep)); then
          : # already owned by this clone — leave untouched (no reload gap)
        elif ((foreign)); then
          rm "$a"
          info "removed stale stow link ~/${a#$HOME/}"
        fi
        break # outermost symlink handled; inner paths vanished with it
      fi
      a="$(dirname "$a")"
    done
  done
}

backup_and_stow() {
  STEP="backup conflicting files"
  purge_stale_stow_links
  local t p backup_dir="" real skip
  for t in "${STOW_TARGETS[@]}"; do
    p="$HOME/$t"
    [[ -e "$p" || -L "$p" ]] || continue
    real="$(readlink -m "$p")"
    # Skip anything that already points into one of our stow packages.
    skip=0
    for sp in "${STOW_PKGS[@]}"; do
      [[ "$real" == "$REPO_DIR/dotfiles/$sp"* ]] && skip=1
    done
    ((skip)) && continue
    if [[ -z "$backup_dir" ]]; then
      backup_dir="$HOME/.config/stow-backup-$(date +%Y%m%d-%H%M%S)"
      mkdir -p "$backup_dir"
    fi
    mkdir -p "$backup_dir/$(dirname "$t")"
    mv "$HOME/$t" "$backup_dir/$t"
    info "backed up ~/$t"
  done
  [[ -n "$backup_dir" ]] && ACTIONS+=("backup in ${backup_dir#$HOME/}")

  STEP="stow ${STOW_PKGS[*]}"
  # Plain stow (no --restow): no-op for already-stowed files, so re-runs
  # never leave a window where configs are missing.
  stow --no-folding --dir "$REPO_DIR/dotfiles" --target "$HOME" "${STOW_PKGS[@]}"
  for t in "${STOW_TARGETS[@]}"; do
    [[ -e "$HOME/$t" ]] || die "stow did not create ~/$t"
  done
  ok "dotfiles stowed (symlinks into ${STOW_PKGS[*]})"
}

# ── .bashrc wiring ──────────────────────────────────────────────────────
wire_bashrc() {
  STEP="wire .bashrc"
  local rc="$HOME/.bashrc"
  if ! grep -q "aliases\.bash" "$rc"; then
    printf '\n# Personal aliases (restored from NixOS config)\nsource "$HOME/.config/bash/aliases.bash"\n' >>"$rc"
    info "added aliases source line"
  else
    SKIPPED+=(".bashrc aliases line already present")
  fi
  if ! grep -q "tools\.bash" "$rc"; then
    printf '\n# Shell tool init (zoxide, fzf, editor)\nsource "$HOME/.config/bash/tools.bash"\n' >>"$rc"
    info "added tools source line"
  else
    SKIPPED+=(".bashrc tools line already present")
  fi
  if ! grep -q "ble\.bash" "$rc"; then
    printf '\n# ble.sh: autosuggestions + syntax highlighting (must come last)\nsource "$HOME/.config/bash/ble.bash"\n' >>"$rc"
    info "added ble.sh source line"
  else
    SKIPPED+=(".bashrc ble.sh line already present")
  fi
  ok ".bashrc wired"
}

# ── xremap (only wired up if the binary is already installed) ───────────
setup_xremap() {
  STEP="xremap setup"
  if ! command -v xremap >/dev/null 2>&1; then
    SKIPPED+=("xremap not installed — CapsLock remap inactive (by design)")
    return 0
  fi

  if [[ ! -f /etc/udev/rules.d/90-uinput.rules ]]; then
    printf '%s\n' "$UDEV_RULE" | sudo tee /etc/udev/rules.d/90-uinput.rules >/dev/null
    sudo udevadm control --reload
    sudo udevadm trigger
    info "wrote udev uinput rule"
  else
    SKIPPED+=("udev uinput rule already present")
  fi

  if [[ ! -f /etc/modules-load.d/uinput.conf ]]; then
    printf 'uinput\n' | sudo tee /etc/modules-load.d/uinput.conf >/dev/null
    info "enabled uinput module at boot"
  else
    SKIPPED+=("uinput module config already present")
  fi

  if ! id -nG "$USER" | tr ' ' '\n' | grep -qx input; then
    sudo usermod -aG input "$USER"
    NEED_RELOGIN=1
    info "added $USER to input group"
  else
    SKIPPED+=("input group membership already set")
  fi

  systemctl --user daemon-reload
  systemctl --user enable xremap-environment.service xremap.service >/dev/null
  if systemctl --user is-active --quiet graphical-session.target; then
    systemctl --user start xremap-environment.service xremap.service
  fi
  ok "xremap services enabled"
}

# ── reload + verify ─────────────────────────────────────────────────────
reload_and_verify() {
  STEP="hyprland reload"
  if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] && command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload >/dev/null
    sleep 1
    local errs
    errs="$(hyprctl configerrors 2>/dev/null || true)"
    if [[ -n "${errs//[[:space:]]/}" && "$errs" != "ok" ]]; then
      warn "Hyprland reported config errors:"
      hyprctl configerrors 2>/dev/null || true
    else
      ok "Hyprland reloaded, no config errors"
    fi
  else
    ACTIONS+=("log into Hyprland (or run 'hyprctl reload') to apply keybinds")
  fi

  STEP="verify"
  local p
  for p in "${PACMAN_PKGS[@]}"; do
    pacman -Qq "$p" >/dev/null 2>&1 || die "verification failed: $p missing"
  done
  command -v stow >/dev/null 2>&1 || die "verification failed: stow not on PATH"
  for p in "${STOW_TARGETS[@]}"; do
    [[ -e "$HOME/$p" ]] || die "verification failed: ~/$p missing"
  done
  if ! bash -ic 'alias ll >/dev/null' >/dev/null 2>&1; then
    die "verification failed: aliases do not load in interactive bash"
  fi
  ok "all checks passed"
}

summary() {
  ((NEED_RELOGIN)) && ACTIONS+=("re-login required for the input group (xremap uinput access)")
  ACTIONS+=("open a NEW terminal for aliases + ble.sh to activate")
  printf '\n%s═══ summary ═══%s\n' "$c_dim" "$c_off"
  local s
  for s in "${DONE[@]:-}";    do [[ -n "$s" ]] && printf '  %s+%s %s\n' "$c_ok" "$c_off" "$s"; done
  for s in "${SKIPPED[@]:-}"; do [[ -n "$s" ]] && printf '  %s·%s %s\n' "$c_dim" "$c_off" "$s"; done
  for s in "${ACTIONS[@]:-}"; do [[ -n "$s" ]] && printf '  %s!%s %s\n' "$c_warn" "$c_off" "$s"; done
  printf '\n%sDone. Keybinds: Super+T terminal, Super+Enter menu, hjkl focus,%s\n' "$c_ok" "$c_off"
  printf '%sCtrl+F accepts the gray command suggestion in bash.%s\n' "$c_ok" "$c_off"
}

main() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      --no-color) USE_COLOR=0 ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown option: $arg (see --help)" ;;
    esac
  done
  preflight
  self_locate
  install_packages
  backup_and_stow
  wire_bashrc
  setup_xremap
  reload_and_verify
  summary
}

main "$@"
