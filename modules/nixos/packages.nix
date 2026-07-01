{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    parted
    nixfmt
    nixfmt-tree
    cachix
    telegram-desktop
    mattermost-desktop
    gcc
    gdb
    gnumake
    eog
  ];
}
