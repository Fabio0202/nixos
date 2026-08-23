# Shell tool initialization (zoxide, fzf, editor).
# Sourced from ~/.bashrc. On Omarchy this duplicates the default init
# (harmless); on Debian this is the only place it happens.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

if command -v fzf >/dev/null 2>&1; then
  [[ -r /usr/share/fzf/key-bindings.bash ]] && source /usr/share/fzf/key-bindings.bash
  [[ -r /usr/share/doc/fzf/examples/key-bindings.bash ]] && source /usr/share/doc/fzf/examples/key-bindings.bash
fi

# Debian ships ripgrep's bat as "batcat"
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  alias bat="batcat"
fi

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="${EDITOR:-nvim}"
fi