{...}: {
  zramSwap.enable = true;

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
}
