{
  config,
  pkgs,
  ...
}: {
  # `light` was removed in nixpkgs 26.05 due to being unmaintained.
  # brightnessctl is provided via home-manager packages as a replacement.
  hardware.brillo.enable = true;

  # DDC/CI: control external monitor brightness over the monitor's I2C bus.
  # The ddcci-driver kernel module exposes DDC-capable external displays as
  # /sys/class/backlight/ddcci* devices, so they show up in brightnessctl and
  # the `~/.local/bin/brightness` helper (which routes by focused monitor).
  boot.kernelModules = [
    "i2c-dev"
    "ddcci"
  ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.ddcci-driver
  ];
  boot.extraModprobeConfig = ''
    options ddcci ddcci_backlight=1
  '';
  environment.systemPackages = with pkgs; [
    ddcutil # DDC/CI control + diagnostics (VCP codes beyond brightness)
  ];
  # Grant the logged-in desktop user access to the I2C bus used by DDC/CI.
  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", KERNEL=="i2c-[0-9]*", TAG+="uaccess"
  '';
}
