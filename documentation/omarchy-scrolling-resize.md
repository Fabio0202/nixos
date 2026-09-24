# Omarchy: Scrolling-layout resize fix (SUPER+I / SUPER+O)

Date: 2026-08-25 · Applies to: Hyprland 0.56.x (Lua config, Omarchy 3.x)

## Problem

On workspaces toggled to the **scrolling** layout (SUPER+SHIFT+Z →
`omarchy-hyprland-workspace-layout-toggle`), the resize keys behaved
erratically:

- SUPER+O ("grow") could visibly **shrink** the window or make it jump
  sideways on any column that is not the leftmost one.
- Resizes were **instant, with no animation** (that part is unfixable,
  see below).

## Root cause

The binds used the generic dispatcher
`hl.dsp.window.resize({ x = ±250, y = ±250, relative = true })`.
In the scrolling layout windows are fractional-width columns on a
horizontal tape, and the generic resize is corner/pointer-based
(`CORNER_NONE` keyboard dispatches take the outer-edge branch in
`ScrollingAlgorithm.cpp::resizeTarget`). After each press the layout
re-fits all columns, so a "grow" on a middle column can net-shrink it.
Verified live: +250 px press shrank a 374 px column to 319 px.

The scrolling layout's own resize is a **layout message**:

```lua
hl.dsp.layout("colresize +0.2")   -- relative, fraction of monitor width
hl.dsp.layout("colresize -0.2")
hl.dsp.layout("colresize 0.5")    -- absolute
hl.dsp.layout("colresize +conf")  -- cycle presets from scrolling.explicit_column_widths
```

## The fix

Already applied in `dotfiles/stow-omarchy/.config/hypr/bindings.lua`
(~/.config/hypr/bindings.lua is a stow symlink to it, so
`omarchy-install.sh` reproduces this on any rebuild — no script changes
needed). Uses the same layout-aware dispatch pattern as the SUPER+J/K
focus binds:

```lua
-- In the scrolling layout, window.resize is corner-based and the re-fit after
-- each press makes it jump around; use the layout's own colresize instead.
local function resize_or_colresize(px, frac)
  return function()
    local active = hl.get_active_workspace()
    if active and active.tiled_layout == "scrolling" then
      hl.dispatch(hl.dsp.layout("colresize " .. (frac > 0 and "+" or "") .. frac))
    else
      hl.dispatch(hl.dsp.window.resize({ x = px, y = px, relative = true }))
    end
  end
end

o.bind("SUPER + I", "Shrink window", resize_or_colresize(-250, -0.15))
o.bind("SUPER + O", "Grow window", resize_or_colresize(250, 0.15))
```

## Verification

1. Toggle a workspace to scrolling (SUPER+SHIFT+Z), open ≥2 windows.
2. Focus a **middle** column, press SUPER+O / SUPER+I repeatedly —
   width must grow/shrink monotonically by ~0.15 monitor-width steps:
   `hyprctl activewindow -j | jq '.size'`
3. `hyprctl reload && hyprctl configerrors` → no errors.
4. Repeat on a dwindle workspace — old pixel resize (±250) still works.

## Known limitations (do NOT try to "fix" these)

- **No resize animation in scrolling layout**: hardwired upstream —
  `resizeTarget()` ends with `recalculate(true)` (forceInstant), which
  calls `warpPositionSize()` on the animated size/position vars.
  Config cannot change this; it would need an upstream Hyprland feature
  request.
- **A lone column cannot be resized**: default
  `scrolling.fullscreen_on_one_column = true` makes a single column span
  the monitor. Resize only does something with 2+ columns.
- On Hyprland ≥0.55, `hyprctl dispatch <msg>` is parsed as Lua and
  silently fails for hyprlang-style args — test with
  `hyprctl eval 'hl.dispatch(...)'` instead.

## Related

- Wiki: https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
- Upstream source: `src/layout/algorithm/tiled/scrolling/ScrollingAlgorithm.cpp`
- [[Hyprland]] · [[hyprland folder structure]]
