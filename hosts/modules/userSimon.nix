
{ config, pkgs, ... }:

{
  users.users.simon = {
    isNormalUser = true;
    description = "simon";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio"  ];
    shell = pkgs.zsh;
  };
}


