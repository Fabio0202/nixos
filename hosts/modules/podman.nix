{ ... }: {
  virtualisation.docker.enable = true;

  users.groups.podman = { };
}
