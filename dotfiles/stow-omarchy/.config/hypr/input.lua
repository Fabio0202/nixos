-- Personal input settings, restored from NixOS config.
-- Layout switching via Alt+Shift (grp:alt_shift_toggle).
--
-- That toggle only does something with more than one layout in kb_layout: a
-- single entry leaves Alt+Shift passing through with no effect and nothing for
-- the bar widget to report. The option must be spelled grp:alt_shift_toggle,
-- as xkb silently drops names it does not know.

-- Rose Pine cursor theme (restored from NixOS).
hl.env("XCURSOR_THEME", "rose-pine-cursor")
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")

hl.config({
  input = {
    -- Two layouts, cycled by Alt+Shift below.
    kb_layout = "us,de",
    -- shift:both_capslock_cancel must NOT be listed here. It claims the second
    -- level of the shift key, which is exactly the slot grp:alt_shift_toggle
    -- needs for ISO_Next_Group, and the caps option wins, leaving Alt+Shift
    -- inert. Caps Lock stays the compose key.
    kb_options = "compose:caps,grp:alt_shift_toggle",
    numlock_by_default = true,
    follow_mouse = 1,
    sensitivity = 0.32,

    touchpad = {
      natural_scroll = true,
    },
  },

  gestures = {
    workspace_swipe_distance = 150,
    workspace_swipe_cancel_ratio = 0.8,
  },
})

-- Touchpad gestures restored from NixOS config.
-- 4-finger vertical swipe changes workspaces.
hl.gesture({ fingers = 4, direction = "vertical", action = "workspace", scale = 0.8 })

-- 3-finger focus navigation (inverted).
hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
hl.gesture({ fingers = 3, direction = "up", action = function() hl.dispatch(hl.dsp.focus({ direction = "d" })) end })
hl.gesture({ fingers = 3, direction = "down", action = function() hl.dispatch(hl.dsp.focus({ direction = "u" })) end })

-- 4-finger horizontal swipe toggles the scroll overview.
hl.gesture({ fingers = 4, direction = "left", action = function() hl.plugin.scrolloverview.overview("toggle all") end })
hl.gesture({ fingers = 4, direction = "right", action = function() hl.plugin.scrolloverview.overview("toggle all") end })