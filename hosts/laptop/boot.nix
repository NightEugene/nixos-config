{ ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.extraEntries = ''
    menuentry "Aurora" {
      search --set=aurora --label boot
      configfile "($aurora)/grub/grub.cfg"
    }
  '';

  boot.kernelParams = ["resume_offset=1632256"];

  boot.resumeDevice = "/dev/disk/by-uuid/9bdf09c9-e4d5-4b48-810f-42b1228cb040";
}
