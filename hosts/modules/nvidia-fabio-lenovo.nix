{
  config,
  lib,
  pkgs,
  ...
}: let
  nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.production;
in {
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = false;

    # Use the package directly
    package = nvidiaPackage;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  boot.kernelParams = ["nvidia-drm.modeset=1"];

  # CRITICAL: Ensure NVIDIA tools are in the system path
  environment.systemPackages = with pkgs; [
    nvidiaPackage
  ];

  # Force the NVIDIA package to be part of the system
  system.requiredKernelConfig = with config.lib.kernelConfig; [
    (isEnabled "NVIDIA")
  ];
}
