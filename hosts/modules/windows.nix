{
  config,
  lib,
  pkgs,
  ...
}: let
  username = "simon";
in {
  options.virtualisation.windows-vm = {
    enable = lib.mkEnableOption "Windows VM configuration for Ableton and light gaming";

    user = lib.mkOption {
      type = lib.types.str;
      default = username;
      description = "User to add to libvirt group";
    };

    memoryAllocation = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "GB of RAM to allocate to VM";
    };

    cpuCores = lib.mkOption {
      type = lib.types.int;
      default = 6;
      description = "Number of CPU cores to allocate to VM";
    };
  };

  config = lib.mkIf config.virtualisation.windows-vm.enable {
    environment.systemPackages = with pkgs; [
      swtpm
      virt-manager
      virt-viewer
      win-virtio
      win-spice
      qemu_kvm
      OVMF
      adwaita-icon-theme
      virtio-win
      spice
      spice-gtk
      spice-protocol
      virglrenderer
      mesa
      looking-glass-client
      usbutils
    ];

    boot = {
      kernelModules = ["kvm-amd" "vfio" "vfio_iommu_type1" "vfio_pci"];
      kernelParams = [
        "amd_iommu=on"
        "iommu=pt"
        "hugepagesz=2M"
        "hugepages=2048"
        "isolcpus=1-5"
      ];
      extraModprobeConfig = "options kvm_amd nested=1";
    };

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
      };
      onBoot = "ignore";
      onShutdown = "shutdown";

      # 👇 put the default NAT network here
      networks = {
        "default" = {
          uuid = "00000000-0000-0000-0000-000000000000";
          forward.mode = "nat";
          bridge = "virbr0";
          domain = "default";
        };
      };
    };

    users.users.${config.virtualisation.windows-vm.user}.extraGroups = ["libvirtd" "kvm" "input"];

    services.spice-vdagentd.enable = true;
    services.qemuGuest.enable = true;

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", GROUP="libvirtd", MODE="0660"
      SUBSYSTEM=="usb_device", GROUP="libvirtd", MODE="0660"
    '';

    environment.sessionVariables = {
      VIRTIO_WIN = "${pkgs.virtio-win}/share/virtio-win";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    # XML template...
    environment.etc."libvirt/qemu/windows-vm-template.xml" = {
      text = ''
        ... your XML ...
      '';
      mode = "0644";
    };
  };
}
