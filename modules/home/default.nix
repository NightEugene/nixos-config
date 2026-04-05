{ pkgs, ... }:

{
  imports = [
    ./niri.nix
  ];

  programs.alacritty.enable = true;
  programs.swaylock.enable = true;

  home = {
    stateVersion = "25.11";

    packages = with pkgs; [
      noctalia-shell
      fastfetch
    ];
  };
}
