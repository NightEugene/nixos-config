{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./term.nix
    ./niri.nix
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  home = {
    stateVersion = "25.11";

    packages = with pkgs; [
      noctalia-shell
      fastfetch
      brightnessctl
      xwayland-satellite
    ];
  };
}
