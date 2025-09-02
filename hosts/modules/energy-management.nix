{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    upower
  ];
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      PLATFORM_PROFILE_ON_BAT = "low-power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
      RUNTIME_PM_ON_AC = "auto";
      WIFI_PWR_ON_AC = "on";
      WIFI_PWR_ON_BAT = "low"; # Added for battery savings
      CPU_MAX_PERF_ON_AC = "100"; # Adjusted for full performance on AC
      CPU_MAX_PERF_ON_BAT = "50"; # Adjusted for balanced performance on battery
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_BOOST_ON_BAT = 0;
      DISK_DEVICES = "sda sdb";
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
      USB_AUTOSUSPEND = true;
    };
  };
  services.thermald.enable = true;
}
