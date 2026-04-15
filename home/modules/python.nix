{pkgs, ...}: {
  # Python packages for users
  home.packages = with pkgs; [
    python312
  ];

  # Poetry configuration for users
  home.sessionVariables = {
    POETRY_VIRTUALENVS_IN_PROJECT = "false";
    POETRY_VIRTUALENVS_PATH = "$HOME/.local/share/poetry/venvs";
  };
}
