_:

{
  boot = {
    # UEFI + GRUB для QEMU.
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        devices = [ "nodev" ];
        useOSProber = false;
      };
      efi.canTouchEfiVariables = false;
    };

    # Для QEMU virtio-gpu modesetting уже включён в ядро.
    kernelParams = [ ];
  };
}
