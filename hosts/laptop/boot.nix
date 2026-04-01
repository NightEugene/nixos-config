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
}
