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
-- SUPER+D was bound to the Mirador shell plugin (removed); now toggles
-- the scrolloverview Hyprland plugin.
hl.unbind("SUPER + D")
o.bind("SUPER + D", "Scroll overview", function()
  hl.plugin.scrolloverview.overview("toggle all")
end)

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- In scrolling layout there's no below/above window, so SUPER+J/K switch
-- workspaces instead (next/previous).
local function focus_or_workspace(dir, ws)
  return function()
    local active = hl.get_active_workspace()
    if active and active.tiled_layout == "scrolling" then
      hl.dispatch(hl.dsp.focus({ workspace = ws }))
    else
      hl.dispatch(hl.dsp.focus({ direction = dir }))
    end
  end
end
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
o.bind("SUPER + J", "Focus below / next workspace", focus_or_workspace("d", "e+1"))
o.bind("SUPER + K", "Focus above / previous workspace", focus_or_workspace("u", "e-1"))

-- ── Keybindings cheatsheet ──────────────────────────────────────────
-- SUPER+ALT+K was "Tmux keybindings".
hl.unbind("SUPER + ALT + K")
o.bind("SUPER + ALT + K", "Keybindings", "omarchy-menu-keybindings")

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

-- In the scrolling layout, window.resize is corner-based and the re-fit after
-- each press makes it jump around; use the layout's own colresize instead.
local function resize_or_colresize(px, frac)
  return function()
    local active = hl.get_active_workspace()
    if active and active.tiled_layout == "scrolling" then
      hl.dispatch(hl.dsp.layout("colresize " .. (frac > 0 and "+" or "") .. frac))
    else
      -- dwindle resize is split-relative: flip the sign vs scrolling
      hl.dispatch(hl.dsp.window.resize({ x = -px, y = -px, relative = true }))
    end
  end
end

o.bind("SUPER + I", "Shrink window", resize_or_colresize(-250, -0.15))
o.bind("SUPER + O", "Grow window", resize_or_colresize(250, 0.15))

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

-- ── System menu ─────────────────────────────────────────────────────
-- SUPER+P was "Pseudo window" (removed). Now mirrors SUPER+ESC (System menu).
hl.unbind("SUPER + P")
o.bind("SUPER + P", "System menu", "omarchy-menu toggle system")

-- ── Screenshots & capture (replaced PRINT keys — not on this keyboard) ──
-- Screenshot moved to SUPER+SHIFT+P (was: Google Photos webapp).
hl.unbind("SUPER + SHIFT + P")
hl.unbind("PRINT")
hl.unbind("ALT + PRINT")
hl.unbind("SUPER + PRINT")
hl.unbind("SUPER + CTRL + PRINT")

o.bind("SUPER + SHIFT + P", "Screenshot", "omarchy-capture-screenshot")
o.bind("SUPER + ALT + P", "Screen recording", "omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord")
o.bind("SUPER + ALT + C", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + SHIFT + I", "Extract text (OCR) from screenshot", "omarchy-capture-text")

-- ── Capture keys: SUPER+C capture menu, SUPER+CTRL+C capture region ──
-- SUPER+C was "Universal copy" (removed), SUPER+CTRL+C was "Capture menu".
hl.unbind("SUPER + C")
hl.unbind("SUPER + CTRL + C")

o.bind("SUPER + C", "Capture menu", "omarchy-menu toggle capture")

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

-- ── Apps: Fastmail instead of HEY ───────────────────────────────────
-- Unbind the old HEY webapp defaults first, then bind Fastmail.
hl.unbind("SUPER + SHIFT + C")
hl.unbind("SUPER + SHIFT + M")
hl.unbind("SUPER + SHIFT + E")

o.bind("SUPER + SHIFT + M", "Google Maps", { webapp = "https://maps.google.com/", focus = true })
hl.unbind("SUPER + SHIFT + ALT + E")
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Capture region", "omarchy-capture-screenshot region")

o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://app.hey.com/calendar/weeks/" })
o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://app.fastmail.com/mail/" })
o.bind("SUPER + SHIFT + ALT + E", "New email", { webapp = "https://app.fastmail.com/mail/compose/" })

-- ── Apps: messaging (Telegram, WhatsApp, Discord) ───────────────────
-- WhatsApp is already bound by default (SUPER+SHIFT+ALT+G), don't re-add.
o.bind("SUPER + SHIFT + T", "Telegram", { launch = "Telegram", focus = "^org.telegram.desktop$" })

-- Discord: use the native app, not the chromium webapp (the webapp's video
-- calls pegged the CPU). SUPER+SHIFT+D was the default "Docker" (lazydocker) TUI.
hl.unbind("SUPER + SHIFT + D")
o.bind("SUPER + SHIFT + D", "Discord", { launch = "discord", focus = "^discord$" })
-- Was the Discord webapp; point the old chord at the native app too.
o.bind("SUPER + SHIFT + ALT + D", "Discord", { launch = "discord", focus = "^discord$" })

-- ── Apps: WhatsApp on SUPER+SHIFT+W; Omawrite moved ─────────────────
-- SUPER+SHIFT+W was "Omawrite" (default); moved to SUPER+SHIFT+ALT+W.
-- Unbind default SUPER+SHIFT+ALT+G (WhatsApp) so it doesn't duplicate
-- the new SUPER+SHIFT+W binding.
hl.unbind("SUPER + SHIFT + W")
hl.unbind("SUPER + SHIFT + ALT + G")

o.bind("SUPER + SHIFT + W", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
o.bind("SUPER + SHIFT + ALT + W", "Omawrite", { launch = "omawrite" })

-- ── Apps: Zen Notes instead of Obsidian ─────────────────────────────
hl.unbind("SUPER + SHIFT + O")

o.bind("SUPER + SHIFT + O", "Zen Notes", { launch = "zennotes", focus = "^ZenNotes$" })

-- ── Apps: remove Grok (not used) ────────────────────────────────────
hl.unbind("SUPER + SHIFT + ALT + A")

-- ── Toggle between last two windows (like C-^ in nvim) ─────────────
-- SUPER+TAB was bound to "Next workspace".
hl.unbind("SUPER + TAB")

o.bind("SUPER + TAB", "Toggle last window", hl.dsp.focus({ last = true }))

-- ── Toggle workspace layout (dwindle ↔ scrolling) ───────────────────
-- SUPER+SHIFT+Z is free. Original was SUPER+L, now used for focus-right.
o.bind("SUPER + SHIFT + Z", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- ── File manager (nautilus) ─────────────────────────────────────────
-- SUPER+F was "Full screen" (still on SUPER+M / ALT+RETURN).
hl.unbind("SUPER + F")
o.bind("SUPER + F", "File manager", { launch = "nautilus" })

-- flea --default: begin. Written by `flea --default`; `flea --default off` removes the block whole.
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = 'flea --gui' })
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { launch = 'flea --gui "$(omarchy-cmd-terminal-cwd)"' })
-- flea --default: end.

