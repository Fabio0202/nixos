{...}: {
  zramSwap.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384; # Increase to 16GB
    }
  ];
}
