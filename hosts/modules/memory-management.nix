{
  config,
  pkgs,
  ...
}: {
  # Early OOM killer to prevent system freeze
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 4; # Kill when <4% memory free
    freeSwapThreshold = 10; # Kill when <10% swap free
    extraArgs = [
      "-g" # Kill entire process groups
      "--avoid" "(^|/)(systemd|ssh|Xorg|gnome-shell|hyprland|soffice|nvim)$" # Protect critical processes
      "--prefer" "(^|/)(firefox|chromium|chrome|electron|node|npm|cargo)$" # Kill these first
    ];
  };

  # Adjust kernel parameters for better memory handling
  boot.kernel.sysctl = {
    "vm.swappiness" = 60; # Use swap more aggressively (default is 60, max 100)
    "vm.vfs_cache_pressure" = 100; # Reclaim cache memory more aggressively
    "vm.overcommit_memory" = 0; # Don't overcommit memory
    "vm.min_free_kbytes" = 65536; # Keep 64MB free for critical operations
    "vm.panic_on_oom" = 0; # Don't panic, let OOM killer work
  };

  # SystemD OOM handling
  systemd.oomd = {
    enable = false; # Disable if using earlyoom (they can conflict)
  };
}

