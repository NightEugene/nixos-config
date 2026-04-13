{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./niri.nix
  ];

  programs.alacritty.enable = true;

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
