# Shell tool initialization (zoxide, fzf, editor).
# Sourced from ~/.bashrc. On Omarchy this duplicates the default init
# (harmless); on Debian this is the only place it happens.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
  # Guarantee C-c and Esc abort the interactive picker (appended after
  # zoxide's own fzf flags, so these bindings take precedence).
  export _ZO_FZF_OPTS="--bind=ctrl-c:abort,esc:abort"
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

# ble.sh (0.3.x) evaluates PROMPT_COMMAND with `eval "$PROMPT_COMMAND"`, which
# on a bash ARRAY runs only element [0] (starship_precmd) and silently drops the
# rest -- so zoxide's __zoxide_hook (and the terminal title printf) never run,
# and zoxide never learns new directories. This file is sourced last in
# ~/.bashrc, so collapse the array into one ';'-joined string here: ble.sh then
# runs every per-prompt hook. (No-op when PROMPT_COMMAND is already a string.)
if declare -p PROMPT_COMMAND 2>/dev/null | grep -q '^declare -a'; then
  _blefix_pc=()
  for _blefix_elem in "${PROMPT_COMMAND[@]}"; do
    [[ -n "${_blefix_elem}" ]] && _blefix_pc+=("${_blefix_elem}")
  done
  if ((${#_blefix_pc[@]})); then
    PROMPT_COMMAND="$(printf '%s;' "${_blefix_pc[@]}")"
    PROMPT_COMMAND="${PROMPT_COMMAND%;}"
  fi
  unset _blefix_pc _blefix_elem
fi