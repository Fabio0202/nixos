{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    poetry

    # Build tools
    gcc
    gnumake
    pkg-config
    poetry # python project management and dependency resolution tool

    # Common C libraries used by Python wheels
    openssl # for cryptography, requests with SSL
    zlib # for compression libs
    libffi # for cffi, cryptography, etc.
    sqlite # for built-in sqlite3 module and ORMs
    cairo # for matplotlib, PyCairo
  ];
}
