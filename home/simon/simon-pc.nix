{ pkgs
, inputs
, pkgs-unstable
, ...
}: {
  # I need to permit insecure packages because of logseq for now
  # not sure if I wanna go the winboat route rn lets see
  # home.packages = with pkgs; [
  #   pkgs-unstable.freerdp
  #   pkgs-unstable.winboat
  # ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    dgop.package = pkgs-unstable.dgop;
    settings = {
      showLauncherButton = false;
      barConfigs = [{
        id = "default";
        name = "Main Bar";
        leftWidgets = ["workspaceSwitcher" "focusedWindow"];
        centerWidgets = ["music" "clock" "weather"];
        rightWidgets = ["systemTray" "clipboard" "cpuUsage" "memUsage" "notificationButton" "battery" "controlCenterButton"];
      }];
    };
  };

  imports = [
    ../modules/gitSimon.nix
    ./common.nix
    ./common-gui.nix
    ../common.nix
  ];
}
