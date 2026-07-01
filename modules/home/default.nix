{ pkgs, inputs, ... }:
{
  imports = [
    ./shell
    ./term.nix
    ./niri.nix
    ./noctalia.nix
    ./vim.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
      opencode
      inputs."kimi-cli".packages.${pkgs.stdenv.hostPlatform.system}.kimi-cli
    ];
  };
}
