{ config
, pkgs
, ...
}: {
  # Early OOM killer to prevent system freeze
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 15; # Kill when <15% memory free (was 4, fired too late)
    freeSwapThreshold = 20; # Kill when <20% swap free
    extraArgs = [
      "-g" # Kill entire process groups
      "--avoid"
      "(^|/)(systemd|ssh|Xorg|gnome-shell|hyprland|soffice|nvim)$" # Protect critical processes
      "--prefer"
      "(^|/)(firefox|chromium|chrome|electron|node|npm|cargo)$" # Kill these first
    ];
  };

  # Adjust kernel parameters for better memory handling
  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Prefer keeping pages in RAM; only swap under real pressure (was 60)
    "vm.vfs_cache_pressure" = 50; # Keep inode/dentry cache, reclaim anonymous pages first (was 100)
    "vm.overcommit_memory" = 0; # Don't overcommit memory
    "vm.min_free_kbytes" = 65536; # Keep 64MB free for critical operations
    "vm.panic_on_oom" = 0; # Don't panic, let OOM killer work
  };

  # SystemD OOM handling
  systemd.oomd = {
    enable = false; # Disable if using earlyoom (they can conflict)
  };
}

