{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./term.nix
    ./niri.nix
    ./noctalia.nix
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  home = {
    stateVersion = "25.11";

    packages = with pkgs; [
      fastfetch
      brightnessctl
      xwayland-satellite
      just
    ];
  };
}
