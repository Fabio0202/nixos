{pkgs, ...}: {
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # Prevent auto-switching bluetooth from A2DP (high quality stereo) to
    # HSP/HFP (low quality mono) when an app opens a mic (e.g. Discord).
    # To use the headset mic, manually switch profile in pavucontrol.
    wireplumber.extraConfig = {
      "11-bluetooth-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol # - A graphical volume control tool for PulseAudio.
    alsa-utils
  ];
}
