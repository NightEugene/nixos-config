{ pkgs, inputs, ... }:
{
  imports = [
    ./shell
    ./term.nix
    ./niri.nix
    ./max.nix
    ./yandex-browser.nix
    ./aurora-sdk.nix
    #./tg-ws-proxy.nix
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
      clang
      telegram-desktop
      mattermost-desktop
      eog
      inputs.kimi-code.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
