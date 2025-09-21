{
  pkgs,
  lib,
  ...
}: let
  # Helper: make services depend on external drive
  needsDrive = {
    after = ["mnt-drive.mount"];
    requires = ["mnt-drive.mount"];
    partOf = ["mnt-drive.mount"];
    serviceConfig.Restart = "on-failure";
    bindsTo = ["mnt-drive.mount"];
  };
in {
  ##########################
  ## Filesystem Integration
  ##########################

  systemd.tmpfiles.rules = [
    "d /mnt/drive/media-config/jellyfin 0755 simon users -"
    "d /mnt/drive/media-config/radarr 0755 simon users -"
    "d /mnt/drive/media-config/sonarr 0755 simon users -"
  ];

  systemd.services = {
    jellyfin = needsDrive;
    radarr = needsDrive;
    sonarr = needsDrive;
    bazarr = needsDrive;
    deluge = needsDrive;
    syncthing = needsDrive; # not defined here, but tied to drive
  };

  ##########################
  ## Media Services
  ##########################

  services.plex.enable = false;

  services.jellyfin = {
    enable = true;
    user = "simon";
    group = "users";
    dataDir = "/mnt/drive/media-config/jellyfin";
  };

  services.radarr = {
    enable = true;
    user = "simon";
    group = "users";
    dataDir = "/mnt/drive/media-config/radarr";
  };

  services.sonarr = {
    enable = true;
    user = "simon";
    group = "users";
    dataDir = "/mnt/drive/media-config/sonarr";
  };

  services.bazarr = {
    enable = true;
    listenPort = 6768;
    user = "simon";
    group = "users";
  };

  services.prowlarr.enable = true;

  services.deluge = {
    enable = true;
    user = "simon";
    group = "users";
    web.enable = true;
    web.port = 8112;
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
    port = 12345;
  };

  services.jackett.enable = false;

  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "dotnet-sdk-6.0.428"
  ];
}
