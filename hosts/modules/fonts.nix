{pkgs, ...}: {
  # Fonts
  fonts = {
    packages = with pkgs; [
      # ✅ Include JetBrainsMono Nerd Font (new style)
      pkgs.nerd-fonts.jetbrains-mono

      # ✅ Include General Sans from a local directory
      (pkgs.stdenv.mkDerivation {
        pname = "general-sans";
        version = "1.0.0";
        src = ./../files/fonts/general-sans;

        installPhase = ''
          mkdir -p $out/share/fonts
          cp -r $src/* $out/share/fonts/
        '';
      })
    ];

    # Font configuration
    fontconfig = {
      defaultFonts = {
        serif = ["Liberation Serif" "Vazirmatn"];
        sansSerif = ["Ubuntu" "General Sans" "Vazirmatn"];
        monospace = ["JetBrainsMono Nerd Font"]; # 👈 Make sure the name matches the actual installed font
      };
    };
  };
}
