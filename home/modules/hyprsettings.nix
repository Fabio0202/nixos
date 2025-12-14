{pkgs, inputs, ...}: {
  home.packages = [
    inputs.hyprsettings.packages.${pkgs.system}.default
  ];
}
