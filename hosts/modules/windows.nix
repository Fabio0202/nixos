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

    # XML template for the Windows VM with TPM
    environment.etc."libvirt/qemu/windows-vm-template.xml" = {
      text = ''
        <domain type='kvm'>
          <name>windows-ableton</name>
          <memory unit='GiB'>${toString config.virtualisation.windows-vm.memoryAllocation}</memory>
          <currentMemory unit='GiB'>${toString config.virtualisation.windows-vm.memoryAllocation}</currentMemory>
          <vcpu placement='static'>${toString config.virtualisation.windows-vm.cpuCores}</vcpu>
          <os>
            <type arch='x86_64' machine='pc-q35-8.2'>hvm</type>
            <loader readonly='yes' type='pflash'>/run/libvirt/ovmf/OVMF_CODE.fd</loader>
            <nvram>/var/lib/libvirt/qemu/nvram/windows-ableton_VARS.fd</nvram>
            <boot dev='hd'/>
          </os>
          <features>
            <acpi/>
            <apic/>
            <hyperv mode='custom'>
              <relaxed state='on'/>
              <vapic state='on'/>
              <spinlocks state='on' retries='8191'/>
            </hyperv>
            <vmport state='off'/>
          </features>
          <cpu mode='host-passthrough' check='none' migratable='on'>
            <topology sockets='1' cores='${toString (config.virtualisation.windows-vm.cpuCores / 2)}' threads='2'/>
            <cache mode='passthrough'/>
          </cpu>
          <clock offset='localtime'>
            <timer name='hpet' present='yes'/>
            <timer name='hypervclock' present='yes'/>
          </clock>
          <on_poweroff>destroy</on_poweroff>
          <on_reboot>restart</on_reboot>
          <on_crash>destroy</on_crash>
          <pm>
            <suspend-to-mem enabled='no'/>
            <suspend-to-disk enabled='no'/>
          </pm>
          <devices>
            <emulator>/run/current-system/sw/bin/qemu-kvm</emulator>
            <disk type='file' device='disk'>
              <driver name='qemu' type='qcow2' cache='none' io='native' discard='unmap'/>
              <source file='/var/lib/libvirt/images/windows-ableton.qcow2'/>
              <target dev='vda' bus='virtio'/>
              <boot order='1'/>
            </disk>

            <!-- TPM device for Windows 11 -->
            <tpm model='tpm-crb'>
              <backend type='emulator' version='2.0'/>
            </tpm>

            <controller type='usb' index='0' model='qemu-xhci' ports='15'/>
            <controller type='pci' index='0' model='pcie-root'/>
            <controller type='pci' index='1' model='pcie-root-port'/>
            <controller type='pci' index='2' model='pcie-root-port'/>
            <controller type='pci' index='3' model='pcie-root-port'/>
            <controller type='pci' index='4' model='pcie-root-port'/>
            <controller type='virtio-serial' index='0'/>
            <controller type='sata' index='0'/>
            <video>
              <model type='virtio' heads='1' primary='yes'>
                <acceleration accel3d='yes'/>
              </model>
            </video>
            <graphics type='spice' port='-1' autoport='yes' listen='127.0.0.1'>
              <listen type='address' address='127.0.0.1'/>
              <gl enable='yes'/>
            </graphics>
            <sound model='ich9'/>
            <audio id='1' type='spice'/>
            <redirdev bus='usb' type='spicevmc'/>
            <memballoon model='virtio'/>
            <rng model='virtio'>
              <backend model='random'>/dev/urandom</backend>
            </rng>
          </devices>
        </domain>
      '';
      mode = "0644";
    };
  };
}
