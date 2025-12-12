{ config
, pkgs
, ...
}: {
  users.users.fabio = {
    isNormalUser = true;
    description = "fabio";
    extraGroups = [ "plugdev" "uinput" "networkmanager" "input" "wheel" "video" "audio" "podman" "docker" ];
    shell = pkgs.zsh;
  };
}
