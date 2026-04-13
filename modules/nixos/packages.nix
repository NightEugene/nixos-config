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
    home-manager
    mattermost-desktop
    gcc
    gdb
    gnumake
  ];
}
