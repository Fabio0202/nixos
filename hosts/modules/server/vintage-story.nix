{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.vintage-story;
  needsDrive = {
    after = ["mnt-drive.mount"];
    requires = ["mnt-drive.mount"];
    partOf = ["mnt-drive.mount"];
    serviceConfig.Restart = "on-failure";
    bindsTo = ["mnt-drive.mount"];
  };

  # Server configuration
  serverConfig = {
    ServerName = cfg.serverName;
    ServerPort = cfg.port;
    MaxClients = cfg.maxClients;
    Password = cfg.password;
    AdvertiseServer = cfg.advertise;
    WhitelistMode = cfg.whitelistMode;
    DefaultRoleCode = cfg.defaultRole;
    SaveFileLocation = "./data/Saves/default.vcdbs";
    ModPaths = ["Mods" "./data/Mods"];
  };

  # Generate serverconfig.json
  serverConfigJson = builtins.toJSON serverConfig;
in {
  options.services.vintage-story = {
    enable = lib.mkEnableOption "Vintage Story dedicated server";

    serverName = lib.mkOption {
      type = lib.types.str;
      default = "Vintage Story Server";
      description = "Name of the server";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 42420;
      description = "Port for the server to listen on";
    };

    maxClients = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Maximum number of clients";
    };

    password = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Server password (null for no password)";
    };

    advertise = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to advertise the server publicly";
    };

    whitelistMode = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Whitelist mode: 'default', 'on', or 'off'";
    };

    defaultRole = lib.mkOption {
      type = lib.types.str;
      default = "suplayer";
      description = "Default role for new players";
    };

    memory = lib.mkOption {
      type = lib.types.str;
      default = "3G";
      description = "Memory allocation for the server";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/drive/vintage-story";
      description = "Directory for server data";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "simon";
      description = "User to run the server as";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "users";
      description = "Group to run the server as";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create data directory
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/data 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/data/Mods 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/data/Saves 0755 ${cfg.user} ${cfg.group} -"
    ];

    # Vintage Story server service
    systemd.services.vintage-story = needsDrive // {
      description = "Vintage Story Dedicated Server";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        RestartSec = 10;
        ExecStart = "${pkgs.dotnet-runtime_8}/bin/dotnet ${cfg.dataDir}/VintagestoryServer.exe --dataPath ${cfg.dataDir}/data";
        # Memory limit
        MemoryMax = cfg.memory;
      };
    };

    # Open firewall ports
    networking.firewall.allowedTCPPorts = [cfg.port];
    networking.firewall.allowedUDPPorts = [cfg.port];

    # Add .NET runtime
    environment.systemPackages = with pkgs; [
      dotnet-runtime_8
    ];
  };
}