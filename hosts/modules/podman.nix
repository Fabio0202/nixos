{...}: {
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  users.groups.podman = {};
}
