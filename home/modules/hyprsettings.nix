{pkgs, inputs, ...}: {
  home.packages = [
    inputs.hyprsettings.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
