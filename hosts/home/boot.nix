{ pkgs, ... }:

{
  # UEFI + GRUB для dual-boot с Windows на sda.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    devices = [ "nodev" ];
    useOSProber = true;
  };

  boot.loader.efi.canTouchEfiVariables = false;

  # Гибернация не используется на десктопе.
  boot.kernelParams = [
    # Для NVIDIA + Wayland рекомендуется keep explicit fbdev.
    "nvidia-drm.fbdev=1"
  ];
}
