{pkgs, ...}: {
  # swww was renamed to awww in nixpkgs 26.05
  home.packages = with pkgs; [
    awww
    waypaper
  ];
}
