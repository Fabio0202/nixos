{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Python (full version with all features)
    (python3Full.withPackages (ps:
      with ps; [
        pip
        virtualenv
        pyserial
      ]))

    # Build tools
    gcc
    gnumake
    pkg-config

    # Common C libraries used by Python wheels
    openssl # for cryptography, requests with SSL
    zlib # for compression libs
    libffi # for cffi, cryptography, etc.
    sqlite # for built-in sqlite3 module and ORMs
    cairo # for matplotlib, PyCairo
  ];
}
