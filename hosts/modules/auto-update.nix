{ config, pkgs, lib, ... }:

let
  cfg = config.services.nixos-auto-update;
  stateDir = "/var/lib/nixos-auto-update";

  notifyUser = pkgs.writeShellScript "notify-update" ''
    for uid in $(${pkgs.coreutils}/bin/ls /run/user/ 2>/dev/null); do
      DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
        ${pkgs.libnotify}/bin/notify-send \
        --urgency=normal \
        --app-name="NixOS Auto-Update" \
        "$1" "$2"
    done
  '';
in {
  options.services.nixos-auto-update = {
    enable = lib.mkEnableOption "automatic NixOS flake update and build";

    flakePath = lib.mkOption {
      type = lib.types.path;
      description = "Path to the NixOS flake directory";
    };

    onCalendar = lib.mkOption {
      type = lib.types.str;
      default = "Sun 03:00";
      description = "systemd calendar expression for when to run";
    };
  };

  config = lib.mkIf cfg.enable {
    # Scheduled timer: updates the flake and marks build as pending
    systemd.services.nixos-auto-update = {
      description = "NixOS flake update (scheduled)";
      serviceConfig = {
        Type = "oneshot";
        Nice = 19;
        IOSchedulingClass = "idle";
        CPUSchedulingPolicy = "idle";
      };
      path = [ pkgs.jujutsu pkgs.git pkgs.nix pkgs.nixos-rebuild ];
      script = ''
        set -euo pipefail
        mkdir -p ${stateDir}

        cd ${cfg.flakePath}
        ${notifyUser} "NixOS Update" "Starting flake update..."

        jj new -m "flake.lock: auto-update"
        nix flake update --flake ${cfg.flakePath} 2>&1

        # Mark build as pending
        echo "$(date --iso-8601=seconds)" > ${stateDir}/pending

        # Attempt the build right away
        hostname=$(hostname)
        if nixos-rebuild build --flake "${cfg.flakePath}#$hostname" 2>&1; then
          rm -f ${stateDir}/pending
          ${notifyUser} "NixOS Update" "Build complete. Run 'sudo nixos-rebuild switch' when ready."
        else
          ${notifyUser} "NixOS Update" "Build interrupted or failed. Will retry on next boot."
        fi
      '';
    };

    systemd.timers.nixos-auto-update = {
      description = "Scheduled NixOS auto-update timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.onCalendar;
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };

    # Boot service: retries the build if a previous run didn't finish
    systemd.services.nixos-auto-update-retry = {
      description = "NixOS auto-update retry (pending build from previous boot)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        Nice = 19;
        IOSchedulingClass = "idle";
        CPUSchedulingPolicy = "idle";
        RemainAfterExit = true;
      };
      path = [ pkgs.git pkgs.nix pkgs.nixos-rebuild ];
      script = ''
        if [ ! -f ${stateDir}/pending ]; then
          echo "No pending build, nothing to do."
          exit 0
        fi

        echo "Pending build found from $(cat ${stateDir}/pending), retrying..."
        ${notifyUser} "NixOS Update" "Resuming pending build from last session..."

        hostname=$(hostname)
        if nixos-rebuild build --flake "${cfg.flakePath}#$hostname" 2>&1; then
          rm -f ${stateDir}/pending
          ${notifyUser} "NixOS Update" "Build complete. Run 'sudo nixos-rebuild switch' when ready."
        else
          ${notifyUser} "NixOS Update" "Build failed again. Will retry on next boot."
        fi
      '';
    };
  };
}
