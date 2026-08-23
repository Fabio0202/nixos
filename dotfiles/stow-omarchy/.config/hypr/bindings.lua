-- Personal keybinding overrides, restored from NixOS config.
-- Merge strategy: Omarchy defaults kept, conflicts overridden.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- ── Focus: vim-style hjkl (restored) ────────────────────────────────
-- SUPER+J was bound to "Toggle window split", SUPER+K to "Keybindings",
-- SUPER+L to "Toggle workspace layout".
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- ── Window movement: hjkl + shift (restored) ────────────────────────
o.bind("SUPER + SHIFT + H", "Move window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + L", "Move window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + J", "Move window to workspace down", hl.dsp.window.move({ workspace = "e+1" }))
o.bind("SUPER + SHIFT + K", "Move window to workspace up", hl.dsp.window.move({ workspace = "e-1" }))

-- ── Workspace switching: SUPER+CTRL+J/K (niri-style) ────────────────
-- SUPER+CTRL+K was bound to "Herdr keybindings".
hl.unbind("SUPER + CTRL + K")

o.bind("SUPER + CTRL + J", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + CTRL + K", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

-- ── Resize: SUPER+I / SUPER+O (niri-style) ──────────────────────────
-- SUPER+O was bound to "Pop window out".
hl.unbind("SUPER + O")

o.bind("SUPER + I", "Shrink window", hl.dsp.window.resize({ x = -250, y = -250, relative = true }))
o.bind("SUPER + O", "Grow window", hl.dsp.window.resize({ x = 250, y = 250, relative = true }))

-- ── Window management (restored) ────────────────────────────────────
-- SUPER+T was bound to "Toggle window floating/tiling" (replaced with terminal).
hl.unbind("SUPER + T")

-- SUPER+G was "Toggle window grouping", SUPER+SHIFT+G was "Signal" webapp.
hl.unbind("SUPER + G")
hl.unbind("SUPER + SHIFT + G")

o.bind("SUPER + T", "Terminal", { omarchy = "terminal" })
o.bind("SUPER + G", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + SHIFT + G", "Toggle window grouping", hl.dsp.group.toggle())
o.bind("SUPER + Q", "Close active window", hl.dsp.window.close())
o.bind("SUPER + M", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("ALT + RETURN", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + Y", "Toggle special workspace", hl.dsp.workspace.toggle_special("special"))
o.bind("SUPER + N", "Move window to special workspace", hl.dsp.window.move({ workspace = "special:special", follow = false }))
o.bind("SUPER + SHIFT + R", "Stop screen recording", "omarchy capture screenrecording --stop-recording")

-- ── Special workspace ───────────────────────────────────────────────
-- Removed SUPER+S "secret workspace" bind (Omarchy default).
hl.unbind("SUPER + S")

-- ── App launcher ────────────────────────────────────────────────────
-- SUPER+RETURN was bound to "Terminal" (replaced with app launcher).
-- SUPER+SPACE also opens the launcher — both work.
hl.unbind("SUPER + RETURN")

o.bind("SUPER + RETURN", "Omarchy menu", "omarchy-menu toggle")

-- ── Browser ────────────────────────────────────────────────────────
o.bind("SUPER + B", "Browser", { launch = "chromium" })

-- ── Audio (restored) ────────────────────────────────────────────────
o.bind("F1", "Mute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
o.bind("F4", "Mute microphone", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
o.bind("ALT + SHIFT", "Switch keyboard layout", "hyprctl switchxkblayout current next")