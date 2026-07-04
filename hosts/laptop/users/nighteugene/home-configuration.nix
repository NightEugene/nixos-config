{ flake, ... }:

{
  imports = [
    flake.homeModules.default
  ];

  programs.tg-ws-proxy = {
    enable = true;
    extraArgs = [
      "--default-domains"
      "--cf-priority"
    ];
  };
}
