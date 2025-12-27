{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    swayosd
    libinput
  ];

  services.mako.enable = true;
  # ✅ Replace the broken services.swayosd with a working user service
  systemd.user.services.swayosd = {
    Unit = {
      Description = "SwayOSD Daemon";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };


}
