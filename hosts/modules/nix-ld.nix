{ pkgs
, config
, lib
, ...
}: {
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      glib
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
    ];
  };
}
