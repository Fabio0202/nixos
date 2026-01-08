{ config, lib, pkgs, ... }:
{
  # Enable greetd display manager with auto-login
  # UWSM handles proper systemd user session activation and graphical-session.target
  # This ensures user services like swayosd start correctly
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # uwsm start is required since Hyprland 0.53+ for proper session management
        # It activates graphical-session.target and starts user services
        command = "start-hyprland";
        user = "simon";
      };
      initial_session = {
        command = "start-hyprland";
        user = "simon";
      };
    };
  };

  # Enable greetd-gtkgreet as a greeter (though with auto-login, this won't be visible)
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
    uwsm  # Required for uwsm start command
  ];

  # Keep essential services that were previously in SDDM config
  services.dbus.enable = true;
  security.polkit.enable = true;
}