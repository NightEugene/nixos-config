{ pkgs, ... }:

let
  max = pkgs.appimageTools.wrapType2 {
    pname = "max";
    version = "latest";
    src = pkgs.fetchurl {
      url = "http://download.max.ru/electron/MAX.AppImage";
      sha256 = "1x1ih59mbrffmyzmamnw5vcn31rdshp4w9chi0hspps4wr886ac2";
    };
    meta = {
      description = "MAX messenger";
      homepage = "https://max.ru";
      license = pkgs.lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    wget
    parted
    nixfmt
    nixfmt-tree
    cachix
    telegram-desktop
    mattermost-desktop
    max
    gcc
    gdb
    gnumake
    eog
  ];
}
