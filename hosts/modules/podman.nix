{pkgs, ...}: {
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true; # optional: makes "docker" command work
  users.users.fabio.extraGroups = ["podman"]; # or "docker" if using dockerCompat
}
