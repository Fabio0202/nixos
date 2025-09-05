{lib, ...}: {
  home.sessionVariables = {
    __GL_GSYNC_ALLOWED = "0"; # disable G-SYNC if it causes flicker
    __GL_VRR_ALLOWED = "0"; # disable VRR (Variable Refresh Rate)

    _JAVA_AWT_WM_NONEREPARENTING = "1"; # fix Java apps on tiling WMs
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";

    GDK_BACKEND = "wayland"; # GTK on Wayland
    ANKI_WAYLAND = "1"; # run Anki natively on Wayland
    MOZ_ENABLE_WAYLAND = "1"; # Firefox/Thunderbird use Wayland

    SDL_VIDEODRIVER = "wayland"; # SDL apps use Wayland
    CLUTTER_BACKEND = "wayland"; # Clutter apps use Wayland
    XDG_SESSION_TYPE = "wayland";

    QT_QPA_PLATFORM = "wayland"; # Qt on Wayland
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt5ct";
    QT_STYLE_OVERRIDE = lib.mkForce "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # let Hyprland handle window borders
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # auto HiDPI scaling

    NIXOS_OZONE_WL = "1"; # Electron/Chromium apps use Wayland
    DIRENV_LOG_FORMAT = ""; # quiet direnv logs

    # GTK_THEME = "Catppuccin-Mocha-Standard-Lavender-Dark"; # optional
  };
}
