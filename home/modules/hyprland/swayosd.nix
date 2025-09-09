{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    swayosd
    libinput
  ];

  services.swayosd = {
    enable = true;
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

  # Sway keybindings example
  # wayland.windowManager.sway.config = {
  #   keybindings = {
  #     "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
  #     "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
  #     "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
  #     "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
  #     "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";
  #     "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";
  #   };
  # };
}
