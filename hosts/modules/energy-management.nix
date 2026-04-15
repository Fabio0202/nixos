{
  config,
  pkgs,
  ...
}: {
  # Enable weekly TRIM for SSDs/NVMe
  # TRIM tells the SSD which blocks are unused
  # Keeps SSD performance from degrading
  # Reduces write amplification → longer SSD lifespan
  # Slightly better power efficiency (less background cleaning)
  services.fstrim.enable = true;
  # Extra tools installed system-wide
  environment.systemPackages = with pkgs; [
    upower # Utility to query battery and power info
    powertop # Tool for measuring and tuning power usage
  ];

  services.upower.enable = true;

  # Let logind handle lid switch — DMS doesn't intercept lid events,
  # and neither does niri (unlike Hyprland which handled it via keybinds)
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "ignore";
  };

  boot.kernelParams = [
    "8250.nr_uarts=0" # disable legacy serial ports → faster boot (most machines don't need them)

    # Use AMD's firmware-level power curve instead of generic acpi-cpufreq.
    # Gives finer-grained voltage/frequency control → 2-4W savings at light load.
    "amd_pstate=active"

    # Suspend idle USB devices after 2s (Linux default, was accidentally disabled with -1).
    "usbcore.autosuspend=30"
  ];

  # Custom Powertop service (non-blocking, runs after boot)
  systemd.services.powertop-autotune = {
    description = "Powertop tunings";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
    };
  };
  systemd.timers.powertop-autotune = {
    description = "Delayed Powertop tunings";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "1min"; # wait 1 minute after boot
      Persistent = true; # catch up if missed
    };
  };

  # power-profiles-daemon for simple profile switching (performance/balanced/power-saver)
  services.power-profiles-daemon.enable = true;

  # Udev rule: trigger Waybar battery module refresh instantly on plug/unplug
  # - SUBSYSTEM=="power_supply": fires when AC adapter or battery state changes
  # - ACTION=="change": only on state change (not every poll)
  # - pkill -RTMIN+10 waybar: send realtime signal to Waybar so it refreshes
  # services.udev.extraRules = ''
  #   SUBSYSTEM=="power_supply", ACTION=="change", \
  #     RUN+="${pkgs.procps}/bin/pkill -RTMIN+10 waybar"
  # '';
}
