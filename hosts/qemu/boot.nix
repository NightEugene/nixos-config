{ pkgs, ... }:

{
  # UEFI + GRUB для QEMU.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    devices = [ "nodev" ];
    useOSProber = false;
  };

  boot.loader.efi.canTouchEfiVariables = false;

  # Для QEMU virtio-gpu modesetting уже включён в ядро.
  boot.kernelParams = [ ];
}
