{ pkgs
, inputs
, pkgs-unstable
, ...
}: {
  # I need to permit insecure packages because of logseq for now
  home.packages = with pkgs; [
    sunshine
    moonlight-qt
    pkgs-unstable.freerdp
    pkgs-unstable.winboat
    # alle Software die ich nur am Laptop haben will
    # TODO: allow unstable imports
    # (pkgs-unstable.vintagestory)
    # (pkgs-unstable.mongodb-compass)
  ];

  imports = [
    ../modules/gitSimon.nix
    ./common.nix
    ./common-gui.nix
    ../common.nix
  ];

  # DISABLED: Using traditional dotfiles instead
  # User-specific config now in ~/dotfiles/stow-simon/hyprland/.config/hypr/user-simon.conf
  # wayland.windowManager.hyprland.settings.input = {
  #   kb_layout = "us, de";
  #   sensitivity = 1.4;
  # };
}
