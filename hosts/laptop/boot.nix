_:

{
  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      extraEntries = ''
        menuentry "Aurora" {
          search --set=aurora --label boot
          configfile "($aurora)/grub/grub.cfg"
        }
      '';
    };

    kernelParams = [ "resume_offset=1632256" ];
    resumeDevice = "/dev/disk/by-uuid/9bdf09c9-e4d5-4b48-810f-42b1228cb040";
  };
}
