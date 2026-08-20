{ config, lib, ... }: {
  # Optimize storage and automatic scheduled GC running
  # If you want to run GC manually, use commands:
  # `nix-store --optimize` for finding and eliminating redundant copies of identical store paths
  # `nix-store --gc` for optimizing the nix store and removing unreferenced and obsolete store paths
  # `nix-collect-garbage -d` for deleting old generations of user profiles
  nix.optimise = {
    automatic = true;
    dates = ["Tue 04:00"];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d"; # give rollback time after manual updates
  };
  # Don't catch up on missed nix-optimise runs — skip if laptop was off
  systemd.timers."nix-optimise".timerConfig.Persistent = lib.mkForce false;
}
