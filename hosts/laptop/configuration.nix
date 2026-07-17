{
  inputs,
  flake,
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

  my.swapFile = {
    enable = true;
    sizeMiB = 16 * 1024;
  };
}
