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
    # ./../modules/server/caddy.nix
    ./../modules/bootloader.nix
    ./../modules/server/media-stack.nix
    ../modules/server/deploy-solid-app.nix
    ./../modules/server/vintage-story.nix
    ../modules/server/whisper-server.nix

    (import ../modules/syncthing {
      user = "simon";
      hostName = "server-schweiz";
    })
  ];
  myApp.enable = true;

  services.nfs.server = {
    enable = true;

    # Export rules
    exports = ''
      # Export the entire drive as root export (fsid=0 lets clients mount subpaths)
      /mnt/drive  100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash,fsid=0)
      # Export specific user clouds directly
      /mnt/drive/cloud/simon  100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash)
      /mnt/drive/cloud/edin   100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash)
      /mnt/drive/cloud/fabio  100.64.0.0/10(rw,sync,no_subtree_check,no_root_squash)
    '';
  };

  # Make NFS (network file system) server depend on your drive being mounted
  systemd.services.nfs-server = {
    after = ["mnt-drive.mount"];
    requires = ["mnt-drive.mount"];
    partOf = ["mnt-drive.mount"];
    bindsTo = ["mnt-drive.mount"];
    serviceConfig.Restart = "on-failure";
  };

  systemd.services.syncthing = {
    after = ["mnt-drive.mount"];
    requires = ["mnt-drive.mount"];
    partOf = ["mnt-drive.mount"];
    bindsTo = ["mnt-drive.mount"];
    serviceConfig.Restart = "on-failure";
  };
  environment.systemPackages = with pkgs; [
    dotnet-runtime_8
    xorg.xauth
    firefox
    cloudflared
  ];

  # Allow installation of proprietary firmware blobs (Wi-Fi, GPU, NIC, etc.)
  # → Required for most laptops and many network adapters to function properly
  hardware.enableRedistributableFirmware = true;
  security.sudo.enable = true;

  # Passwordless sudo for common system operations
  security.sudo.extraRules = [
    {
      users = ["simon"];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start jellyfin";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop jellyfin";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart jellyfin";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl start jellyseerr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop jellyseerr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart jellyseerr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl start syncthing";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop syncthing";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart syncthing";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl start sonarr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop sonarr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart sonarr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl start radarr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop radarr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart radarr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl start bazarr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop bazarr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart bazarr";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/mount";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/umount";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
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
  # This rule makes systemd “watch” for your specific disk by UUID, and immediately mount it when it appears, instead of lazily waiting.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="${UUID}", ENV{SYSTEMD_WANTS}+="mnt-drive.mount"
  '';

  # Vintage Story Server Configuration
  services.vintage-story = {
    enable = false;
    serverName = "Simon's Vintage Story Server";
    port = 42420;
    maxClients = 10;
    password = null; # Set a password if desired
    advertise = false; # Keep private for friends
    whitelistMode = "default"; # Whitelist enabled by default
    defaultRole = "suplayer";
    memory = "3G"; # Allocate 3GB RAM
    user = "simon";
    group = "users";
  };

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
}
