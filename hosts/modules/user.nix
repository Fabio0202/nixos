
{ config, pkgs, ... }:

{
  users.users.fabio = {
    isNormalUser = true;
    description = "fabio";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio"  ];
    shell = pkgs.zsh;
  };
}


