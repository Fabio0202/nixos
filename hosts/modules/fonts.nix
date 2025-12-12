{ pkgs, ... }: {
  # Fonts
  fonts = {
    packages = with pkgs; [
      # ✅ Include JetBrainsMono Nerd Font (new style)
      pkgs.nerd-fonts.jetbrains-mono
    ];

    # Font configuration
    fontconfig = {
      defaultFonts = {
        serif = [ "Liberation Serif" "Vazirmatn" ];
        sansSerif = [ "Ubuntu" "Vazirmatn" ];
        monospace = [ "JetBrainsMono Nerd Font" ]; # 👈 Make sure the name matches the actual installed font
      };
    };
  };
}
