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

    ../modules/userSimon.nix
    ./../configuration-common-server.nix
    ./../modules/server/cloudflared.nix
    ./../modules/server/caddy.nix
    ./../modules/bootloader.nix
    ./../modules/server/media-stack.nix

    (import ../modules/syncthing {
      user = "simon";
      hostName = "server-schweiz";
    })
  ];

  # TODO: move to media-stack.nix
  systemd.services.syncthing = {
    after = ["mnt-drive.mount"];
    requires = ["mnt-drive.mount"];
    bindsTo = ["mnt-drive.mount"];
  };
  environment.systemPackages = with pkgs; [
    xorg.xauth
    firefox
    cloudflared
  ];

  hardware.enableRedistributableFirmware = true;
  security.sudo.enable = true;
  boot.extraModulePackages = with config.boot.linuxPackages; [
    rtl88xxau-aircrack
  ];

  # Enable Intel iGPU video acceleration
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [intel-media-driver];
  };

  users.users.simon.extraGroups = ["video" "wheel"];
  programs.zsh.enable = true;
  networking.hostName = "server";

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
