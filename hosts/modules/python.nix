{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python312Full # Full Python 3.12 with commonly used packages
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
