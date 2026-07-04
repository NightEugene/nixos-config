{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    parted
    nixfmt
    nixfmt-tree
    cachix
    gcc
    gdb
    gnumake
  ];
}
