-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Load hyprpm-enabled plugins (e.g. scrolloverview) at session start.
-- o.exec_on_start waits for the hyprland.start event; a bare hl.exec_cmd runs
-- during config evaluation, before the event loop accepts requests, and
-- hyprpm's plugin load gets silently dropped.
o.exec_on_start("hyprpm reload")
