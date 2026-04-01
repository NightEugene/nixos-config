{ pkgs, ... }:

{
  imports = [
    ./network.nix
    ./time.nix
    ./programs.nix
    ./packages.nix
    ./services.nix
    ./users.nix
  ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
