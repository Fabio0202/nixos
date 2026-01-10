{ pkgs, ... }:

let
  obsidian-fhs = pkgs.buildFHSEnv {
    name = "obsidian-fhs";
    
    targetPkgs = pkgs: with pkgs; [
      obsidian
      # Core dependencies for Electron apps
      gtk3
      glib
      nss
      nspr
      atk
      cairo
      pango
      gdk-pixbuf
      freetype
      fontconfig
      dbus
      xorg.libX11
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libXScrnSaver
      xorg.libxcb
      
      # Plugin development dependencies
      nodejs
      nodePackages.npm
      python3
      python3Packages.pip
      git
      
      # Common plugin dependencies
      curl
      wget
      unzip
      tar
      which
      
      # Additional runtime libraries
      stdenv.cc.cc
      zlib
      openssl
      expat
      libffi
    ];
    
    multiPkgs = pkgs: with pkgs; [
      # Multi-arch packages if needed
    ];
    
    profile = ''
      export NIX_LD=${pkgs.stdenv.cc.libc}/lib/ld-linux-x86-64.so.2
      export ELECTRON_IS_DEV=0
      export OBSIDIAN_DISABLE_GPU=0
    '';
    
    runScript = "obsidian";
  };
in
{
  home.packages = [ obsidian-fhs ];
}