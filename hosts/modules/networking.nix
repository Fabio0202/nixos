{
  config,
  pkgs,
  ...
}: {
  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [
    # `iw` - A command-line tool for configuring and managing WiFi devices.
    iw

    # `wpa_supplicant` - Essential for managing WiFi connections, often used with NetworkManager.
    wpa_supplicant

    # `networkmanager` - A service to manage network connections, including Ethernet and WiFi.
    networkmanager
  ];

  networking.hostName = "fabio"; # Define your hostname.
}
