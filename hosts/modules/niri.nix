{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # niri pulls in gcr-ssh-agent which conflicts with programs.ssh.startAgent in system.nix
  services.gnome.gcr-ssh-agent.enable = false;

  # XWayland support for niri (niri doesn't have built-in XWayland)
  environment.systemPackages = [ pkgs.xwayland-satellite ];
}
