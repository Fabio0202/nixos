{ pkgs, ... }: {
  # Core graphics setup — hardware-specific drivers (AMD, Intel, etc.)
  # are handled by nixos-hardware in each host's configuration.nix
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    libva-utils # contains `vainfo`, to check VA-API hardware video decode
    vulkan-tools # contains `vulkaninfo`, to check Vulkan support
    mesa-demos # provides `glxinfo`, to check OpenGL support
  ];
}
