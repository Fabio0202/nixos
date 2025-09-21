{
  config,
  pkgs,
  inputs,
  ...
}: let
  UUID = "04c67b4a-ead1-4613-9abc-2985e9202e5c";
in {
  imports = [
    ./hardware-configuration.nix
    ./../configuration-common.nix
    ./../modules/server/syncthing.nix
    ./../modules/server/cloudflared.nix
    ./../modules/server/caddy.nix
    ./../modules/server/media-stack.nix
    # ./../modules/nginx.nix
  ];

  environment.systemPackages = with pkgs; [
    xorg.xauth
    firefox
    cloudflared
  ];

  hardware.enableRedistributableFirmware = true;
  security.sudo.enable = true;
  boot.extraModulePackages = with pkgs.linuxPackages; [
    rtl88xxau-aircrack
  ];

  # Enable Intel iGPU video acceleration
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [intel-media-driver];
  };

  users.users.simon.extraGroups = ["video" "wheel"];
  programs.zsh.enable = true;
  networking.hostName = "simon-server";

  ##########################
  ## Drive Configuration
  ##########################

  services.fstrim.enable = true;

  fileSystems."/mnt/drive" = {
    device = "/dev/disk/by-uuid/${UUID}";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=1s"
      "x-systemd.automount"
    ];
  };

  # Mount the moment the disk appears
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="${UUID}", ENV{SYSTEMD_WANTS}+="mnt-drive.mount"
  '';

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
}
