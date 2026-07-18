{ config, pkgs, inputs, lib, ... }:

let
  wallpaperFile = "${./noctaliaPCWallpaper.jpg}";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;
    settings = pkgs.replaceVars ./noctaliaPC.toml {
      inherit wallpaperFile;
    };
  };
}
