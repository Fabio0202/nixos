# Shell aliases

# Basic commands
alias mkdir="mkdir -p"
alias rm="trash-put"
alias open="xdg-open"

# SSH control
alias ssh-allow="sudo systemctl start sshd"
alias ssh-deny="sudo systemctl stop sshd"

# Navigation
alias l="eza --icons"
alias ls="eza --icons"
alias ll="eza -lha --icons=auto --sort=name --group-directories-first"
alias lst="ls -T -L=2"
alias lg="ls | grep"
alias ".."="cd .."
alias "..."="cd ../.."
alias b="cd .."
alias c="z"
alias cd="z"
alias ci="zi"
alias cadd="zoxide add"
alias cdadd="zoxide add"

# File managers
alias fl="y"
alias lf="y"

# Tools
alias ping="gping"
alias gg="lazygit"
alias oc="opencode"

# Typo fixes
alias nivm="nvim"

# Taskwarrior
alias t="task"
alias tt="taskwarrior-tui"
alias td="task done"
alias ta="task add"
alias tm="task modify"
alias tc="task context"

# Python (global wrappers)
alias pip="pip-global"
alias pip3="pip-global"
alias python="python-global"
alias python3="python-global"

# NixOS update
update() {
  local flake_dir="${NIXOS_FLAKE_DIR:-$HOME/nixos}"
  local host="${1:-$(hostname)}"

  if [ ! -e "$flake_dir/flake.nix" ]; then
    echo "update: missing flake at $flake_dir (set NIXOS_FLAKE_DIR or clone to ~/nixos)" >&2
    return 1
  fi

  sudo nixos-rebuild switch --flake "$flake_dir#$host" --impure || return $?

  if [ -d "$flake_dir/dotfiles" ]; then
    if ! command -v stow >/dev/null 2>&1; then
      echo "update: stow not found; skipping restow (install pkgs.stow then re-run update)" >&2
      return 0
    fi

    stow --dir="$flake_dir/dotfiles" --target="$HOME" --restow stow-common zsh ssh || return $?
  fi
}

# Project setup
alias mkpy='
    poetry init -n --python "^3.12"
    poetry env use $(which python3)
    poetry install --no-root

    cat > .envrc <<'\''EOF'\''
# use Poetry virtualenv automatically
PYTHON_FULL=$(which python3)

# ensure venv is built with the correct Python
if ! poetry env info -p 2>/dev/null | grep -q "$PYTHON_FULL"; then
  echo "Rebuilding Poetry venv using $PYTHON_FULL..."
  poetry env use "$PYTHON_FULL"
  poetry install --no-root
fi

# activate venv so "python" and "pip" work directly
VENV_PATH=$(poetry env info --path 2>/dev/null || true)
if [ -n "$VENV_PATH" ] && [ -d "$VENV_PATH" ]; then
  source "$VENV_PATH/bin/activate"
  echo "Activated Poetry virtualenv"
else
  echo "No Poetry virtualenv found. Run '\''poetry install'\''."
fi
EOF

    direnv allow
    echo "Project ready! Type '\''python main.py'\'' directly."
'
