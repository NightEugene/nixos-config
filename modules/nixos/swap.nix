{ config, lib, ... }:

let
  cfg = config.my.swapFile;
in
{
  options.my.swapFile = {
    enable = lib.mkEnableOption "swap file at /var/lib/swapfile";

    sizeMiB = lib.mkOption {
      type = lib.types.int;
      default = 16 * 1024;
      description = "Size of /var/lib/swapfile in MiB.";
    };
  };

  config = lib.mkIf cfg.enable {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = cfg.sizeMiB;
      }
    ];
  };
}
