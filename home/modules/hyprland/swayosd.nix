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

  # Optional: Custom CSS theming
  xdg.configFile."swayosd/style.css".text = ''
    .osd {
      background-color: rgba(30, 30, 46, 0.9);
      border-radius: 12px;
      padding: 8px 8px;
    }

    progressbar > trough {
      background-color: #414458;
      border-radius: 8px;
      padding: 8px;
    }

    progressbar > trough > progress {
      background: linear-gradient(to right, #f38ba8, #f5c2e7);
      border-radius: 8px;
    }
  '';
}
