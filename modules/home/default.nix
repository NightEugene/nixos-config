{ pkgs, ... }:
{
  imports = [
    ./shell
    ./term.nix
    ./niri.nix
    ./noctalia.nix
    ./vim.nix
  ];

  home = {
    stateVersion = "25.11";

    packages = with pkgs; [
      fastfetch
      brightnessctl
      xwayland-satellite
      just
      nh
      tree
      opencode
    ];
  };
}
