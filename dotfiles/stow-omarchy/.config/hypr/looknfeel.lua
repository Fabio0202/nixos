-- Personal look'n'feel, restored from NixOS config.
-- Gaps, blur, and rounding. Animations stay at Omarchy defaults.

hl.config({
  general = {
    gaps_out = 12,
    gaps_in = 5,
    border_size = 1,
  },

  decoration = {
    rounding = 4,

    shadow = {
      enabled = true,
      range = 4,
    },

    blur = {
      enabled = true,
      size = 15,
      passes = 2,
      noise = 0.01,
      contrast = 1.1,
      brightness = 0.9,
      vibrancy = 1.0,
      popups = false,
    },
  },
})

