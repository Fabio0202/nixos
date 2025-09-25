{...}: {
  virtualisation.docker.enable = true;
  # virtualisation.podman.dockerCompat = true;

  users.groups.podman = {};
}
