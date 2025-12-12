{ pkgs, ... }: {
  hardware.graphics = {
    # Enable the OpenGL/Vulkan stack system-wide
    enable = true;

    # Also provide 32-bit libraries (needed for Steam, Wine, Proton, Lutris, etc.)
    enable32Bit = true;

    # Extra GPU-related packages to install into the driver stack
    # These are mostly "glue" libraries so apps can talk to the GPU:
    extraPackages = with pkgs; [
      libva-vdpau-driver # bridge VAAPI (video acceleration API) → VDPAU
      libvdpau # VDPAU video acceleration library
      vulkan-loader # Vulkan ICD loader (finds the correct Vulkan driver)
      vulkan-validation-layers # useful debug/validation layers for Vulkan apps
    ];

    # Same as above, but for 32-bit apps (games, Wine, Steam runtime)
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      libvdpau
      vulkan-loader
    ];
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools # contains `vulkaninfo`, to check Vulkan support
    mesa-demos # provides `glxinfo`, to check OpenGL support
  ];
}
