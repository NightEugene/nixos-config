{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    parted
    nixfmt
    nixfmt-tree
  ];
}
