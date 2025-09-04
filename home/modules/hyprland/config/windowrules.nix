{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    # Keybindings
    # Window rules
    extraConfig = ''
                windowrulev2 = opacity 0.98 0.85,class:^(firefox)$

      windowrulev2 = float, class:^(waydroid)$
                windowrulev2 = opacity 1.00 0.90,class:^(Brave-browser)$
                windowrulev2 = opacity, 0.85 0.85 class:^(Wofi)$
                windowrulev2 = opacity, 0.85 0.85 class:^(org.telegram.desktop)$
                windowrulev2 = opacity, 0.85 0.85 class:^(wofi)$
                windowrulev2 = stayfocused, class:^(com\.bitwig\.BitwigStudi)$, xwayland:1
          #     windowrulev2 = noinitialfocus, class:^(com\.bitwig\.BitwigStudi)$, xwayland:1
          #     windowrulev2 = nofocus, class:^(com\.bitwig\.BitwigStudi)$, xwayland:1
          #     windowrulev2 = float, class:^(com\.bitwig\.BitwigStudi)$, xwayland:1
                windowrulev2 = opacity 0.80 0.80,class:^(Steam)$
                windowrulev2 = opacity 0.80 0.80,class:^(steam)$
                windowrulev2 = opacity 0.80 0.80,class:^(steamwebhelper)$
                windowrulev2 = opacity 0.80 0.80,class:^(Spotify)$
                windowrulev2 = opacity 0.80 0.80,class:^(Code)$
                windowrulev2 = opacity 0.80 0.80,class:^(code-url-handler)$
                windowrulev2 = opacity 0.95 0.90,class:^(kitty)$
                windowrulev2 = opacity 0.95 0.90,class:^(neovide)$
                windowrulev2 = opacity 0.80 0.80,class:^(org.gnome.Nautilus)$
                windowrulev2 = opacity 0.80 0.80,class:^(org.kde.ark)$
                windowrulev2 = opacity 0.80 0.80,class:^(nwg-look)$
                windowrulev2 = opacity 0.80 0.80,class:^(qt5ct)$

                windowrulev2 = opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$ #Clapper-Gtk
                windowrulev2 = opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$ #Flatseal-Gtk
                windowrulev2 = opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$ #Cartridges-Gtk
                windowrulev2 = opacity 0.80 0.80,class:^(com.obsproject.Studio)$ #Obs-Qt
                windowrulev2 = opacity 0.80 0.80,class:^(gnome-boxes)$ #Boxes-Gtk
                windowrulev2 = opacity 0.95 0.90, ,class:^(WebCord)$ #WebCord-Electron
                windowrulev2 = opacity 0.80 0.80,class:^(app.drey.Warp)$ #Warp-Gtk
                windowrulev2 = opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$ #ProtonUp-Qt
                windowrulev2 = opacity 0.80 0.80,class:^(yad)$ #Protontricks-Gtk
                windowrulev2 = opacity 0.80 0.80,class:^(Signal)$ #Signal-Gtk
                windowrulev2 = opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$ #Upscaler-Gtk

                windowrulev2 = opacity 0.80 0.70,class:^(pavucontrol)$
                windowrulev2 = opacity 0.80 0.70,class:^(blueman-manager)$
                windowrulev2 = opacity 0.80 0.70,class:^(nm-applet)$
                windowrulev2 = opacity 0.80 0.70,class:^(nm-connection-editor)$
                windowrulev2 = opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$

                windowrulev2 = float,class:^(qt5ct)$
                windowrulev2 = float,class:^(nwg-look)$
                windowrulev2 = float,class:^(org.kde.ark)$
                windowrulev2 = float,class:^(Signal)$ #Signal-Gtk
                windowrulev2 = float,class:^(com.github.rafostar.Clapper)$ #Clapper-Gtk
                windowrulev2 = float,class:^(app.drey.Warp)$ #Warp-Gtk
                windowrulev2 = float,class:^(net.davidotek.pupgui2)$ #ProtonUp-Qt
                windowrulev2 = float,class:^(yad)$ #Protontricks-Gtk
                windowrulev2 = float,class:^(eog)$ #Imageviewer-Gtk
                windowrulev2 = float,class:^(io.gitlab.theevilskeleton.Upscaler)$ #Upscaler-Gtk
                windowrulev2 = float,class:^(pavucontrol)$
                windowrulev2 = float,class:^(blueman-manager)$
                windowrulev2 = float,class:^(waypaper)$
                windowrulev2 = float,class:^(nm-applet)$
                windowrulev2 = float,class:^(nm-connection-editor)$
                windowrulev2 = float,class:^(org.kde.polkit-kde-authentication-agent-1)$
                windowrulev2 = float,class:^(org.kde.dolphin)$
                windowrulev2 = size 60%,class:^(org.kde.dolphin)$
                # windowrulev2 = pin ,class:^(WebCord)$ #WebCord-Electron
                windowrulev2 = float, workspace:specialworkspace
                windowrulev2 = float,class:^(Spotify)$
                windowrulev2 = float,class:^(wofi)$
                windowrulev2 = float,class:^(slack)$
                windowrulev2 = suppressevent maximize,            class:(neovide)
                windowrulev2 = float, class:^nwg-dock$
                # windowrulev2 = float,class:^(telegram-desktop)$


                windowrulev2 = opacity 0.0 override,class:^(xwaylandvideobridge)$
                windowrulev2 = noanim,class:^(xwaylandvideobridge)$
                windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$
                windowrulev2 = maxsize 1 1,class:^(xwaylandvideobridge)$
                windowrulev2 = noblur,class:^(xwaylandvideobridge)$

    '';
  };
}
