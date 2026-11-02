_:

{
  boot = {
    # UEFI + GRUB для dual-boot с Windows на sda.
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        devices = [ "nodev" ];
        useOSProber = true;
      };
      efi.canTouchEfiVariables = false;
    };

    kernelParams = [
      # Для NVIDIA + Wayland рекомендуется keep explicit fbdev.
      "nvidia-drm.fbdev=1"
    ];
  };
}
