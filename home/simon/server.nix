{ pkgs
, pkgs-unstable
, ...
}: {
  # I need to permit insecure packages because of logseq for now
  home.packages = with pkgs; [
    # Diagnostic tools for debugging processes and open resources
    lsof    # List open files, network connections, and processes
    psmisc  # Contains fuser - identify/kill processes using files or sockets
  ];

  imports = [
    ./common.nix
    ../common-server.nix
    ../modules/gitSimon.nix
  ];
}
