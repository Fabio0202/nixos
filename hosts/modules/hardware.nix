{pkgs, ...}: {
  # Enable virtual input devices support

  environment.systemPackages = with pkgs; [
    udiskie
  ];
  hardware.uinput.enable = true;

  # Enable udisks2 for auto-mounting external drives
  services.udisks2.enable = true;

  users.groups.plugdev.members = ["fabio"];
  # Add user 'simon' to groups for uinput and input device access
  users.groups.uinput.members = ["fabio"];
  users.groups.input.members = ["fabio"];
}
