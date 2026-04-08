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

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB in MB
    }
  ];
}
