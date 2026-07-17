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

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit flake;
    };
    users.nighteugene = import ./users/nighteugene/home-configuration.nix;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB in MB
    }
  ];
}
