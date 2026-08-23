# Personal shell aliases, restored from NixOS config (adapted for bash).
# Sourced from ~/.bashrc.

# Basic commands
alias mkdir="mkdir -p"
alias cld="claude --dangerously-skip-permissions"
if command -v trash-put &>/dev/null; then
  alias rm="trash-put"
fi

# Navigation (guarded for compatibility)
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

# zoxide (Omarchy already sets cd -> zd; add the rest)
if command -v zoxide &>/dev/null; then
  alias c="z"
  alias ci="zi"
  alias cadd="zoxide add"
  alias cdadd="zoxide add"
fi

# File managers
if command -v yazi &>/dev/null; then
  alias fl="y"
  alias lf="y"
  # y: yazi that cds into the dir you quit from
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi

# Tools
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