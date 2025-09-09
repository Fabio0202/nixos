{pkgs, ...}: {
  environment.systemPackages = with pkgs; [udiskie];

  hardware.uinput.enable = true;
  services.udisks2.enable = true;

  # make sure groups exist
  users.groups = {
    plugdev = {};
    uinput = {};
    input = {};
  };

  # add all normal users automatically to these groups
  users.extraGroupsForNormalUsers = ["plugdev" "uinput" "input"];
}
