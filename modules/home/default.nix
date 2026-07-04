{ pkgs, inputs, ... }:
{
  imports = [
    ./shell
    ./term.nix
    ./niri.nix
    ./max.nix
    ./yandex-browser.nix
    ./aurora-sdk.nix
    ./tg-ws-proxy.nix
    ./noctalia.nix
    ./vim.nix
  ];

  programs.tg-ws-proxy.secret = "99bfddf5454e8cf1ea0c927c167d848b";

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
      clang
      inputs."kimi-cli".packages.${pkgs.stdenv.hostPlatform.system}.kimi-cli
    ];
  };
}
