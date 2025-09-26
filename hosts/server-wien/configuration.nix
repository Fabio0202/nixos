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

    ../modules/userFabio.nix
    ./../configuration-common-server.nix
    ./../modules/bootloader.nix
    # (import ../modules/syncthing {
    #   user = "fabio";
    #   hostName = "server-wien";
    # })
  ];

  services.nfs.server = {
    enable = true;

    # Export rules
    # exports = ''
    #   # Export the entire drive as root export (fsid=0 lets clients mount subpaths)
    #   /mnt/drive  100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash,fsid=0)
    #   # Export specific user clouds directly
    #   /mnt/drive/cloud/simon  100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash)
    #   /mnt/drive/cloud/edin   100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash)
    #   /mnt/drive/cloud/fabio  100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash)
    # '';
  };

  # Make NFS server depend on your drive being mounted
  # systemd.services.nfs-server = {
  #   after = ["mnt-drive.mount"];
  #   requires = ["mnt-drive.mount"];
  #   partOf = ["mnt-drive.mount"];
  #   bindsTo = ["mnt-drive.mount"];
  #   serviceConfig.Restart = "on-failure";
  # };
  #
  # systemd.services.syncthing = {
  #   after = ["mnt-drive.mount"];
  #   requires = ["mnt-drive.mount"];
  #   partOf = ["mnt-drive.mount"];
  #   bindsTo = ["mnt-drive.mount"];
  #   serviceConfig.Restart = "on-failure";
  # };
  environment.systemPackages = with pkgs; [
    xorg.xauth
  ];

  # Allow installation of proprietary firmware blobs (Wi-Fi, GPU, NIC, etc.)
  # → Required for most laptops and many network adapters to function properly
  hardware.enableRedistributableFirmware = true;
  security.sudo.enable = true;

  # enable intel igpu video acceleration
  hardware.opengl = {
    enable = true;
    extrapackages = with pkgs; [intel-media-driver];
  };

  users.users.simon.extraGroups = ["video" "wheel"];
  programs.zsh.enable = true;
  networking.hostName = "server";

  ##########################
  ## Drive Configuration
  ##########################

  services.fstrim.enable = true;

  # fileSystems."/mnt/drive" = {
  #   device = "/dev/disk/by-uuid/${UUID}";
  #   fsType = "ext4";
  #   options = [
  #     "nofail"
  #     "x-systemd.device-timeout=1s"
  #     "x-systemd.automount"
  #   ];
  # };

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
}
