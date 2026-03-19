{
  config,
  pkgs,
  lib,
  ...
}: let
  homeDir = config.home.homeDirectory;

  # Distrobox assemble manifest for a dev container with node, python, etc.
  distroboxAssemble = pkgs.writeText "distrobox-dev.ini" ''
    [dev]
    image=docker.io/library/ubuntu:24.04
    replace=true
    start_now=false
    init=false
    nvidia=false
    pull=true
    additional_packages="curl wget git zsh sudo build-essential python3 python3-pip python3-venv nodejs npm"
  '';

  # Script to create/recreate the dev distrobox
  distrobox-setup = pkgs.writeShellScriptBin "distrobox-setup" ''
    echo "Creating dev distrobox from assemble file..."
    ${pkgs.distrobox}/bin/distrobox assemble create --file ${distroboxAssemble}
    echo ""
    echo "Dev container created! Enter with: dbe dev"
    echo ""
    echo "To install extra tools inside:"
    echo "  sudo apt install -y <package>"
    echo ""
    echo "To export a GUI app to host:"
    echo "  distrobox-export --app <app-name>"
    echo ""
    echo "To export a CLI tool to host:"
    echo "  distrobox-export --bin /usr/bin/<tool> --export-path ~/.local/bin"
  '';

  # Script to run a command inside the dev distrobox without entering it
  distrobox-run = pkgs.writeShellScriptBin "dbr" ''
    container="''${1:-dev}"
    shift 2>/dev/null
    if [ $# -eq 0 ]; then
      echo "Usage: dbr [container] <command...>"
      echo "  dbr npm install        # run in 'dev' container"
      echo "  dbr mybox npm install  # run in 'mybox' container"
      exit 1
    fi
    exec ${pkgs.distrobox}/bin/distrobox enter "$container" -- "$@"
  '';
in {
  home.packages = [
    distrobox-setup
    distrobox-run
  ];

  programs.zsh.initExtra = ''
    # Distrobox shortcuts
    alias dbe="distrobox enter"
    alias dbl="distrobox list"
    alias dbs="distrobox stop"
    alias dbrm="distrobox rm"

    # Quick enter dev container
    alias dev="distrobox enter dev"
  '';
}
