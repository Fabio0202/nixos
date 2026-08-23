-- Personal input settings, restored from NixOS config.
-- Layout switching via Left+Right Alt (grp:alts_toggle).

hl.config({
  input = {
    kb_layout = "us,de",
    kb_options = "grp:alts_toggle",
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

-- 3-finger focus navigation.
hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
hl.gesture({ fingers = 3, direction = "up", action = function() hl.dispatch(hl.dsp.focus({ direction = "u" })) end })
hl.gesture({ fingers = 3, direction = "down", action = function() hl.dispatch(hl.dsp.focus({ direction = "d" })) end })