{ pkgs, ... }: {
  # Python packages for users
  home.packages = with pkgs; [
    python312
    python312Packages.tkinter
    pipx

    (pkgs.writeShellScriptBin "pip-global" ''
      VENV_DIR="$HOME/.local/share/global-python"
      if [ ! -d "$VENV_DIR" ]; then
        echo "Creating global Python environment..."
        ${pkgs.python312}/bin/python3 -m venv --system-site-packages "$VENV_DIR"
      fi
      unset PIP_USER
      "$VENV_DIR/bin/pip" "$@"
    '')

    (pkgs.writeShellScriptBin "python-global" ''
      VENV_DIR="$HOME/.local/share/global-python"
      if [ ! -d "$VENV_DIR" ]; then
        echo "Creating global Python environment..."
        ${pkgs.python312}/bin/python3 -m venv --system-site-packages "$VENV_DIR"
      fi
      export NIX_LD_LIBRARY_PATH="''${NIX_LD_LIBRARY_PATH:-/run/current-system/sw/share/nix-ld/lib}"
      export LD_LIBRARY_PATH="''${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$NIX_LD_LIBRARY_PATH"
      "$VENV_DIR/bin/python" "$@"
    '')
  ];

  # Poetry configuration for users
  home.sessionVariables = {
    POETRY_VIRTUALENVS_IN_PROJECT = "false";
    POETRY_VIRTUALENVS_PATH = "$HOME/.local/share/poetry/venvs";
  };

  # Python aliases for global environment
  programs.zsh.shellAliases = {
    pip = "pip-global";
    pip3 = "pip-global";
    python = "python-global";
    python3 = "python-global";
  };
}
