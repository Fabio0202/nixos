{pkgs, ...}: {
  home.packages = [pkgs.hyprlock pkgs.manrope];
  xdg.configFile."hypr/hyprlock.conf".text = ''
            $red = rgb(f38ba8)
            $yellow = rgb(f9e2af)
            $lavender = rgb(b4befe)

            $mauve = rgb(cba6f7)
            $mauveAlpha = cba6f7

            $base = rgb(1e1e2e)
            $surface0 = rgb(313244)
            $text = rgb(cdd6f4)
            $textAlpha = cdd6f4

            $accent = $lavender
            $accentAlpha = $mauveAlpha
            $font = "Manrope Thin"


            # GENERAL
            general {
              disable_loading_bar = true
              hide_cursor = true
            }

            # BACKGROUND
            background {
              monitor =
              path = ~/nixos/files/wallpapers/plants.jpg
              color = $base
              blur_passes = 2
            }

          # TIME
          label {
            text = cmd[update:30000] echo "$(date +"%H:%M")"
            font_size = 100
            font_family = $font
            color = $text
            position = 0, 0   # top element
            halign = center
            valign = center
          }

          # DATE
          label {
            text = cmd[update:43200000] echo "$(date +"%A, %B %d")"
            font_size = 28
            font_family = $font
            color = $text
            position = 0, -100   # just below the time
            halign = center
            valign = center
          }



        # INPUT FIELD
    input-field {
      monitor =
      size = 300, 60
      outline_thickness = 2
      rounding = 30
      inner_color = rgba(49, 50, 68, 0.5)   # semi-transparent
      outer_color = rgba(180, 190, 254, 0.6)
      font_color = $text
      placeholder_text = <span foreground="##$textAlpha"><i>󰌾  Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
      hide_input = false
      check_color = $accent
      fail_color = $red
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
      capslock_color = $yellow
      position = 0, -220
      halign = center
      valign = center
    }
  '';
}
