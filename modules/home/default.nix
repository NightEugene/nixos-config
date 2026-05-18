{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nix4nvchad.homeManagerModules.default

    ./shell
    ./term.nix
    ./niri.nix
    ./noctalia.nix
  ];

  programs.nvchad = {
    enable = true;
  };

  home = {
    stateVersion = "25.11";

    packages = with pkgs; [
      fastfetch
      brightnessctl
      xwayland-satellite
      just
      nh
      tree
      ripgrep
    ];
  };
}
