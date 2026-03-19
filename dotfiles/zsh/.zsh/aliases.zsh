# Shell aliases

# Basic commands
alias mkdir="mkdir -p"
if command -v trash-put &>/dev/null; then
  alias rm="trash-put"
fi
alias ggl='noglob _ggl'
_ggl() {
  w3m "https://lite.duckduckgo.com/lite/?q=$(printf '%s' "$*" | jq -sRr @uri)"
}

# SSH control
alias ssh-allow="sudo systemctl start sshd"
alias ssh-deny="sudo systemctl stop sshd"

# Navigation (guarded for distrobox compatibility)
if command -v eza &>/dev/null; then
  alias l="eza --icons"
  alias ls="eza --icons"
  alias ll="eza -lha --icons=auto --sort=name --group-directories-first"
  alias lst="ls -T -L=2"
  alias lsg="ls | grep"
else
  alias l="ls"
  alias ll="ls -lha"
  alias lst="ls"
  alias lsg="ls | grep"
fi
alias ".."="cd .."
alias "..."="cd ../.."
alias b="cd .."
if command -v zoxide &>/dev/null; then
  alias c="z"
  alias cd="z"
  alias ci="zi"
  alias cadd="zoxide add"
  alias cdadd="zoxide add"
fi

# File managers
if command -v yazi &>/dev/null; then
  alias fl="y"
  alias lf="y"
fi

# Tools
if command -v gping &>/dev/null; then
  alias ping="gping"
fi
if command -v lazygit &>/dev/null; then
  alias gg="lazygit"
fi
if command -v opencode &>/dev/null; then
  alias oc="opencode"
fi

# Typo fixes
alias nivm="nvim"

# Taskwarrior
alias t="task"
alias tt="taskwarrior-tui"
alias td="task done"
alias ta="task add"
alias tm="task modify"
alias tc="task context"

# Python (global wrappers - only on NixOS host)
if command -v pip-global &>/dev/null; then
  alias pip="pip-global"
  alias pip3="pip-global"
fi
if command -v python-global &>/dev/null; then
  alias python="python-global"
  alias python3="python-global"
fi

# NixOS update
update() {
  local flake_dir="${NIXOS_FLAKE_DIR:-$HOME/nixos}"
  local host="${1:-$(hostname)}"

  if [ ! -e "$flake_dir/flake.nix" ]; then
    echo "update: missing flake at $flake_dir (set NIXOS_FLAKE_DIR or clone to ~/nixos)" >&2
    return 1
  fi

  sudo nixos-rebuild switch --flake "$flake_dir#$host" --impure
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
