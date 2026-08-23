#!/usr/bin/env bash
# debian-install.sh — vanilla Debian server -> Simon's CLI setup.
#
# Usage (from anywhere):
#   curl -fsSL https://raw.githubusercontent.com/Fabio0202/nixos/master/debian-install.sh | bash
# Or from a clone:
#   ./debian-install.sh
#
# Installs: neovim, lazygit, eza, zoxide, fzf, yazi, ble.sh, opencode,
# tailscale + the shared aliases (stow-cli package). No GUI stuff.
# Safe to re-run: every step is guarded and idempotent.
set -Eeuo pipefail

REPO_URL="https://github.com/Fabio0202/nixos.git"
BRANCH="master"
STOW_PKG="stow-cli"
APT_PKGS=(neovim git curl stow fzf jq ripgrep bat btop trash-cli unzip tar xz-utils ca-certificates openssh-server)

STOW_TARGETS=(
  ".config/bash/aliases.bash"
  ".config/bash/ble.bash"
  ".config/bash/tools.bash"
)

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

SKIPPED=() ACTIONS=()

# Run a command as root (directly or via sudo).
as_root() {
  if ((EUID == 0)); then "$@"; else sudo "$@"; fi
}

usage() {
  cat <<EOF
debian-install.sh — Simon's CLI setup for Debian servers.

  curl -fsSL https://raw.githubusercontent.com/Fabio0202/nixos/master/debian-install.sh | bash

Options:
  --no-color   disable colored output
  -h, --help   show this help
EOF
}

# ── pre-flight ──────────────────────────────────────────────────────────
preflight() {
  STEP="pre-flight"
  # Binaries install into ~/.local/bin and ~/.opencode/bin — make sure THIS
  # script can find them (for skip-logic and verification), not just shells.
  case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH" ;; esac
  case ":$PATH:" in *":$HOME/.opencode/bin:"*) ;; *) export PATH="$HOME/.opencode/bin:$PATH" ;; esac
  [[ -r /etc/os-release ]] || die "no /etc/os-release — not Debian?"
  . /etc/os-release
  case " ${ID:-} ${ID_LIKE:-} " in
    *" debian "*) : ;;
    *) die "this script targets Debian (found: ${ID:-unknown})" ;;
  esac
  command -v apt-get >/dev/null || die "apt-get not found."
  command -v curl >/dev/null || die "curl not found."
  [[ -f "$HOME/.bashrc" ]] || die "$HOME/.bashrc not found."
  case "$(uname -m)" in
    x86_64) ARCH=x86_64 ;;
    aarch64|arm64) ARCH=aarch64 ;;
    *) die "unsupported architecture: $(uname -m)" ;;
  esac
  if ((EUID != 0)) && ! sudo -n true >/dev/null 2>&1 && [[ ! -t 0 ]]; then
    die "not root and sudo needs a password — run interactively or as root."
  fi
  ok "pre-flight passed (Debian, $ARCH, $( ((EUID==0)) && echo root || echo user ))"
}

# If the script runs without its repo next to it (curl | bash), use a
# persistent managed clone so the stow symlinks stay valid after the run.
self_locate() {
  STEP="locate"
  local script_dir
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
  if [[ -d "$script_dir/dotfiles/$STOW_PKG" ]]; then
    REPO_DIR="$script_dir"
    return
  fi
  info "script was piped/downloaded — syncing managed clone"
  local managed="$HOME/.local/share/server-dotfiles/nixos"
  if [[ -d "$managed/.git" ]]; then
    git -C "$managed" fetch --depth 1 origin "$BRANCH" \
      && git -C "$managed" reset --hard FETCH_HEAD >/dev/null \
      || die "failed to update managed clone"
  else
    mkdir -p "$(dirname "$managed")"
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$managed" \
      || die "git clone failed"
  fi
  exec bash "$managed/debian-install.sh" "$@"
}

# ── packages ────────────────────────────────────────────────────────────
install_apt() {
  STEP="apt packages"
  local missing=() p
  for p in "${APT_PKGS[@]}"; do
    dpkg-query -W -f='${Status}' "$p" 2>/dev/null | grep -q "install ok installed" \
      || missing+=("$p")
  done
  if ((${#missing[@]})); then
    info "installing: ${missing[*]}"
    as_root env DEBIAN_FRONTEND=noninteractive apt-get update -qq
    as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends "${missing[@]}"
  else
    SKIPPED+=("apt packages already installed")
  fi
  ok "apt packages ready"

  STEP="sshd"
  if command -v sshd >/dev/null 2>&1; then
    if systemctl is-enabled --quiet ssh; then
      SKIPPED+=("sshd already enabled")
    else
      as_root systemctl enable --now ssh
      ok "sshd enabled (ssh on port 22)"
    fi
  else
    SKIPPED+=("openssh-server not installed — skipping sshd enable")
  fi
}

# ── keyboard layout (us,de + Alt+Shift toggle) ──────────────────────────
setup_keyboard() {
  STEP="keyboard layout"
  local kbd=/etc/default/keyboard
  if [[ -f "$kbd" ]] && grep -q 'XKBLAYOUT="us,de"' "$kbd"; then
    SKIPPED+=("keyboard layout already us,de")
    return 0
  fi
  as_root tee "$kbd" >/dev/null <<'EOF'
# Configured by debian-install.sh (matches Simon's desktop setup).
XKBMODEL="pc105"
XKBLAYOUT="us,de"
XKBVARIANT=""
XKBOPTIONS="grp:alts_toggle"
BACKSPACE="guess"
EOF
  # Apply to the current console + X11/VTs (safe to ignore if not present).
  as_root setupcon --save 2>/dev/null || true
  ok "keyboard layout us,de (Alt+Shift toggles)"
}

# Latest release tag of a GitHub repo (grep-based, no jq/python needed).
gh_latest() {
  curl -fsSL --max-time 15 "https://api.github.com/repos/$1/releases/latest" \
    | grep -oP '"tag_name":\s*"\K[^"]+' || die "could not resolve latest release of $1"
}

# install_gh_bin <repo> <asset-with-$VER> <binary-inside-archive>
# Downloads the release archive and puts the binary into ~/.local/bin.
install_gh_bin() {
  local repo=$1 asset_tpl=$2 inner=$3
  local name tag ver tmp asset
  name="$(basename "$inner")"
  if command -v "$name" >/dev/null 2>&1; then
    SKIPPED+=("$name already installed")
    return 0
  fi
  tag="$(gh_latest "$repo")"
  ver="${tag#v}"
  asset="${asset_tpl//\$\{VER\}/$ver}"
  tmp="$(mktemp -d)"
  info "installing $name ($tag)"
  curl -fsSL --max-time 120 -o "$tmp/a" \
    "https://github.com/$repo/releases/download/$tag/$asset" \
    || { warn "download failed: $name"; return 0; }
  case "$asset" in
    *.zip) unzip -qq "$tmp/a" -d "$tmp/x" ;;
    *) tar -xf "$tmp/a" -C "$tmp" ;;
  esac
  mkdir -p "$HOME/.local/bin"
  mv "$tmp/x/$inner" "$HOME/.local/bin/$name" 2>/dev/null \
    || mv "$tmp/$inner" "$HOME/.local/bin/$name" \
    || { warn "archive layout unexpected: $name"; return 0; }
  chmod +x "$HOME/.local/bin/$name"
  rm -rf "$tmp"
}

install_binaries() {
  STEP="release binaries"
  case "$ARCH" in
    x86_64)
      install_gh_bin jesseduffield/lazygit "lazygit_\${VER}_linux_x86_64.tar.gz" "lazygit"
      install_gh_bin ajeetdsouza/zoxide "zoxide-\${VER}-x86_64-unknown-linux-musl.tar.gz" "zoxide"
      install_gh_bin eza-community/eza "eza_x86_64-unknown-linux-musl.tar.gz" "eza"
      install_gh_bin sxyazi/yazi "yazi-x86_64-unknown-linux-musl.zip" "yazi-x86_64-unknown-linux-musl/yazi"
      ;;
    aarch64)
      install_gh_bin jesseduffield/lazygit "lazygit_\${VER}_linux_arm64.tar.gz" "lazygit"
      install_gh_bin ajeetdsouza/zoxide "zoxide-\${VER}-aarch64-unknown-linux-musl.tar.gz" "zoxide"
      install_gh_bin eza-community/eza "eza_aarch64-unknown-linux-musl.tar.gz" "eza"
      install_gh_bin sxyazi/yazi "yazi-aarch64-unknown-linux-musl.zip" "yazi-aarch64-unknown-linux-musl/yazi"
      ;;
  esac
  # opencode: official installer (installs to ~/.opencode, fixes PATH itself)
  if command -v opencode >/dev/null 2>&1; then
    SKIPPED+=("opencode already installed")
  else
    info "installing opencode"
    curl -fsSL --max-time 120 https://opencode.ai/install | bash \
      || warn "opencode install failed — rerun to retry"
  fi
  ok "release binaries ready"
}

# ble.sh is not packaged on Debian — extract the release tarball to
# ~/.local/share/blesh (ble.bash sources it from there).
install_blesh() {
  STEP="ble.sh"
  if [[ -r "$HOME/.local/share/blesh/ble.sh" ]]; then
    SKIPPED+=("ble.sh already installed")
    return 0
  fi
  local tag tmp
  tag="$(gh_latest akinomyoga/ble.sh)"
  tmp="$(mktemp -d)"
  info "installing ble.sh ($tag)"
  curl -fsSL --max-time 60 -o "$tmp/ble.tar.xz" \
    "https://github.com/akinomyoga/ble.sh/releases/download/$tag/ble-${tag#v}.tar.xz" \
    || { warn "ble.sh download failed — no autosuggestions/highlighting"; return 0; }
  mkdir -p "$HOME/.local/share/blesh"
  tar -xJf "$tmp/ble.tar.xz" -C "$HOME/.local/share/blesh" --strip-components=1
  rm -rf "$tmp"
  [[ -r "$HOME/.local/share/blesh/ble.sh" ]] || warn "ble.sh layout unexpected"
}

install_tailscale() {
  STEP="tailscale"
  if command -v tailscale >/dev/null 2>&1; then
    SKIPPED+=("tailscale already installed")
    return 0
  fi
  info "installing tailscale"
  curl -fsSL --max-time 120 https://tailscale.com/install.sh | as_root sh \
    || warn "tailscale install failed — rerun to retry"
}

# ── backup + stow ───────────────────────────────────────────────────────
backup_and_stow() {
  STEP="backup conflicting files"
  local t a real backup_dir="" keep_prefix="$REPO_DIR/dotfiles/$STOW_PKG"
  for t in "${STOW_TARGETS[@]}"; do
    a="$HOME/$t"
    while [[ "$a" != "$HOME" && "$a" != "/" ]]; do
      if [[ -L "$a" ]]; then
        real="$(readlink -m "$a")" # -m resolves dangling links too
        if [[ "$real" != "$keep_prefix"* && "$real" == */dotfiles/$STOW_PKG/* ]]; then
          rm "$a"
          info "removed stale stow link ~/${a#$HOME/}"
        fi
        break
      fi
      a="$(dirname "$a")"
    done
    a="$HOME/$t"
    if [[ -e "$a" || -L "$a" ]]; then
      real="$(readlink -m "$a")"
      [[ "$real" == "$keep_prefix"* ]] && continue
      if [[ -z "$backup_dir" ]]; then
        backup_dir="$HOME/.config/stow-backup-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$backup_dir"
      fi
      mkdir -p "$backup_dir/$(dirname "$t")"
      mv "$a" "$backup_dir/$t"
      info "backed up ~/$t"
    fi
  done
  [[ -n "$backup_dir" ]] && ACTIONS+=("backup in ${backup_dir#$HOME/}")

  STEP="stow $STOW_PKG"
  stow --no-folding --dir "$REPO_DIR/dotfiles" --target "$HOME" "$STOW_PKG"
  for t in "${STOW_TARGETS[@]}"; do
    [[ -e "$HOME/$t" ]] || die "stow did not create ~/$t"
  done
  ok "dotfiles stowed"
}

# ── .bashrc wiring ──────────────────────────────────────────────────────
wire_bashrc() {
  STEP="wire .bashrc"
  local rc="$HOME/.bashrc"
  if ! grep -q 'export PATH=.*\.local/bin' "$rc"; then
    printf '\ncase ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) export PATH="$HOME/.local/bin:$PATH";; esac\n' >>"$rc"
    info "added ~/.local/bin to PATH"
  fi
  for f in tools aliases ble; do
    if ! grep -q "$f\.bash" "$rc"; then
      printf 'source "$HOME/.config/bash/%s.bash"\n' "$f" >>"$rc"
      info "added $f.bash source line"
    else
      SKIPPED+=(".bashrc $f line already present")
    fi
  done
  ok ".bashrc wired"
}

# ── verify ──────────────────────────────────────────────────────────────
verify() {
  STEP="verify"
  local b
  for b in nvim lazygit eza zoxide fzf; do
    command -v "$b" >/dev/null 2>&1 || die "verification failed: $b missing"
  done
  for t in "${STOW_TARGETS[@]}"; do
    [[ -e "$HOME/$t" ]] || die "verification failed: ~/$t missing"
  done
  bash -ic 'alias ll >/dev/null' >/dev/null 2>&1 \
    || die "verification failed: aliases do not load in interactive bash"
  command -v yazi >/dev/null 2>&1 || warn "yazi missing (fl/lf aliases inactive)"
  { command -v opencode >/dev/null 2>&1 || [[ -x "$HOME/.opencode/bin/opencode" ]]; } \
    || warn "opencode missing (oc alias inactive)"
  command -v tailscale >/dev/null 2>&1 || warn "tailscale missing"
  ok "all checks passed"
}

summary() {
  ACTIONS+=("run 'tailscale up' to join your tailnet (if installed just now)")
  ACTIONS+=("open a NEW shell for aliases + ble.sh to activate")
  printf '\n%s═══ summary ═══%s\n' "$c_dim" "$c_off"
  local s
  for s in "${SKIPPED[@]:-}"; do [[ -n "$s" ]] && printf '  %s·%s %s\n' "$c_dim" "$c_off" "$s"; done
  for s in "${ACTIONS[@]:-}"; do [[ -n "$s" ]] && printf '  %s!%s %s\n' "$c_warn" "$c_off" "$s"; done
  printf '\n%sDone. ll (ls), c (smart cd), gg (lazygit), oc (opencode), rm -> trash.%s\n' "$c_ok" "$c_off"
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
  install_apt
  setup_keyboard
  install_binaries
  install_blesh
  install_tailscale
  backup_and_stow
  wire_bashrc
  verify
  summary
}

main "$@"
