{
  inputs,
  flake,
  lib,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    flake.nixosModules.default

    ./boot.nix
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  # ThinkPad: fan/thermal management is handled by EC + DYTC,
  # thermald refuses to run on this platform.
  services.thermald.enable = lib.mkForce false;

  # USB pairing and communication with iPhone/iPad.
  services.usbmuxd.enable = true;

  my.swapFile = {
    enable = true;
    sizeMiB = 16 * 1024;
  };
}
