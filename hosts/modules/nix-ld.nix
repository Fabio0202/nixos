{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      glib
      # --- The "Missing Pieces" for Electron/Paper.design ---
      libdrm
      libxkbcommon
      mesa
      nss
      nspr
      at-spi2-atk
      at-spi2-core
      dbus
      expat
      pango
      cairo
      libva
      libxshmfence
      libcap
      systemd # for libudev

      # --- Often needed for newer AppImages ---
      libxcrypt-legacy # many old binaries look for libcrypt.so.1
      gtk3
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXrandr
      xorg.libXtst
      xorg.libXcursor
      xorg.libXfixes
      xorg.libXi
      xorg.libSM
      xorg.libICE
      xorg.libXt
      xorg.libXmu
      xorg.libXpm
      freetype
      fontconfig
      alsa-lib
      libpulseaudio
      ncurses5
      libuuid
      curl
      libxml2
      mesa # provides GL + GLU
      libGL
      libGLU
      portaudio # audio I/O (used by voice dictation / faster-whisper)
    ];
  };
}
