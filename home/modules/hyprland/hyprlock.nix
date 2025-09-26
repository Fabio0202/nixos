{pkgs, ...}: {
  home.packages = [pkgs.hyprlock]; # make sure SF Pro is available
  xdg.configFile."hypr/hyprlock.conf".text = ''
    $red      = rgb(f38ba8)
    $yellow   = rgb(f9e2af)
    $lavender = rgb(b4befe)

    $base     = rgb(1e1e2e)
    $surface0 = rgb(313244)
    $text     = rgb(ffffff)   # pure white
    $subtext  = rgb(bac2de)   # subtle gray for secondary

    $accent   = $lavender
    $font     = "SF Pro Display"

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

    # TIME (big, centered)
    label {
      text = cmd[update:30000] echo "$(date +"%H:%M")"
      font_size = 120
      font_family = $font
      color = $text
      position = 0, 0
      halign = center
      valign = center
    }

    # DATE (smaller, below)
    label {
      text = cmd[update:43200000] echo "$(date +"%A, %B %d")"
      font_size = 26
      font_family = $font
      color = $subtext
      position = 0, -140
      halign = center
      valign = center
    }

    # INPUT FIELD (sleek pill style)
    input-field {
      monitor =
      size = 360, 52
      outline_thickness = 1
      rounding = 26
      inner_color = rgba(255, 255, 255, 0.1)
      outer_color = rgba(255, 255, 255, 0.25)
      font_color = $text
      placeholder_text = <span foreground="#bac2de"><i>󰌾  $USER</i></span>
      hide_input = false
      check_color = $accent
      fail_color = $red
      fail_text = <i>Wrong password</i>
      capslock_color = $yellow
      position = 0, -220
      halign = center
      valign = center
    }
  '';
}
