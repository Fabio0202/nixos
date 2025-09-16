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

  boot.kernelParams = [
    "8250.nr_uarts=0" # disable legacy serial ports → faster boot (most machines don't need them)

    # Automatically suspend idle USB devices after a short timeout.
    # → Lowers power use (esp. webcam, fingerprint, smartcard reader) when idle.
    "usbcore.autosuspend=-1"
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

  # Disable GNOME’s power-profiles-daemon (TLP is better)
  services.power-profiles-daemon.enable = false;

  # TLP manages advanced power-saving for CPU, GPU, WiFi, disks, USB
  services.tlp = {
    enable = true;
    settings = {
      # General power profile when on battery
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # CPU performance/power settings
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # prioritize power savings
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power"; # balanced on AC
      CPU_MAX_PERF_ON_AC = "100"; # allow full performance on AC
      CPU_MAX_PERF_ON_BAT = "50"; # limit performance on battery
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave"; # use powersave governor
      CPU_BOOST_ON_BAT = 0; # disable turbo boost on battery

      # Runtime power management (PCI devices)
      RUNTIME_PM_ON_AC = "auto";

      # Wi-Fi power saving
      WIFI_PWR_ON_AC = "on";
      WIFI_PWR_ON_BAT = "low";

      # Disk Advanced Power Management (APM) levels
      DISK_DEVICES = "sda sdb"; # list of managed disks
      DISK_APM_LEVEL_ON_AC = "254 254"; # max performance on AC
      DISK_APM_LEVEL_ON_BAT = "128 128"; # more aggressive savings on battery

      # USB autosuspend for unused devices
      USB_AUTOSUSPEND = false;
    };
  };

  # Enable thermald (Intel/AMD thermal daemon)
  # Dynamically adjusts CPU throttling to keep temps under control
  services.thermald.enable = true;

  # Udev rule: trigger Waybar battery module refresh instantly on plug/unplug
  # - SUBSYSTEM=="power_supply": fires when AC adapter or battery state changes
  # - ACTION=="change": only on state change (not every poll)
  # - pkill -RTMIN+10 waybar: send realtime signal to Waybar so it refreshes
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ACTION=="change", \
      RUN+="${pkgs.procps}/bin/pkill -RTMIN+10 waybar"
  '';
}
