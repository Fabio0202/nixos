{pkgs, ...}: {
  # Python packages for users
  home.packages = with pkgs; [
    python312Full
  ];

  # Create global Python environment for pip installs
  home.file.".local/bin/pip-global" = {
    text = ''
      #!/usr/bin/env bash
      VENV_DIR="$HOME/.local/share/global-python"
      
      if [ ! -d "$VENV_DIR" ]; then
        echo "Creating global Python environment..."
        ${pkgs.python312Full}/bin/python3 -m venv --system-site-packages "$VENV_DIR"
      fi
      
      # Unset PIP_USER to prevent conflicts with venv
      unset PIP_USER
      "$VENV_DIR/bin/pip" "$@"
    '';
    executable = true;
  };

  home.file.".local/bin/python-global" = {
    text = ''
      #!/usr/bin/env bash
      VENV_DIR="$HOME/.local/share/global-python"
      
      if [ ! -d "$VENV_DIR" ]; then
        echo "Creating global Python environment..."
        ${pkgs.python312Full}/bin/python3 -m venv --system-site-packages "$VENV_DIR"
      fi
      
      # Ensure NIX_LD paths are set for C extensions
      export NIX_LD_LIBRARY_PATH="''${NIX_LD_LIBRARY_PATH:-/run/current-system/sw/share/nix-ld/lib}"
      export LD_LIBRARY_PATH="''${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$NIX_LD_LIBRARY_PATH"
      
      "$VENV_DIR/bin/python" "$@"
    '';
    executable = true;
  };

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