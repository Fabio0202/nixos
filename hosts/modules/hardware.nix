{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ udiskie ];

  hardware.uinput.enable = true;
  services.udisks2.enable = true;

  users.groups = {
    plugdev = { };
    uinput = { };
    input = { };
  };
}
