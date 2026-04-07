{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    parted
    nixfmt
    nixfmt-tree
    cachix
    telegram-desktop
    openvpn
    powertop
    docker
  ];
}
