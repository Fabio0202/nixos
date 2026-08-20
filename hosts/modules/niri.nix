{ lib, pkgs, pkgs-unstable, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs-unstable.niri;
  };

  # niri pulls in gcr-ssh-agent which conflicts with programs.ssh.startAgent in system.nix
  services.gnome.gcr-ssh-agent.enable = false;

  # XWayland support for niri (niri doesn't have built-in XWayland)
  environment.systemPackages = [ pkgs.xwayland-satellite ];

  # Portal backends — niri's nixpkgs module auto-adds xdg-desktop-portal-gnome
  # but that requires GNOME Shell to function. Use gtk for OpenURI/FileChooser
  # since xdg-desktop-portal-gtk works without any desktop shell and is already
  # pulled in by hyprlandWM.nix.
  xdg.portal.config.niri = {
    # Override the nixpkgs niri module default ([ "gnome" "gtk" ]) to use
    # gtk for OpenURI so clicking links works without GNOME Shell.
    "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
  };
}
