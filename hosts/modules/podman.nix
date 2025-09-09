{pkgs, ...}: {
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  # ensure all normal users get podman group
  users.groups.podman = {}; # create podman group if it doesn't exist

  users.mutableUsers = false; # optional, if you want declarative-only users
  users.extraGroupsForNormalUsers = ["podman"];
}
