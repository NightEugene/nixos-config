{ config, pkgs, inputs, lib, ... }:

let
  rawSettings = (builtins.fromJSON (builtins.readFile ./noctaliaPC.json)).settings;

  substituteHome =
    value:
    if builtins.isString value then
      lib.replaceStrings [ "/home/nighteugene" ] [ "${config.home.homeDirectory}" ] value
    else if builtins.isList value then
      map substituteHome value
    else if builtins.isAttrs value then
      lib.mapAttrs (_: substituteHome) value
    else
      value;

  wallpaperFile = "${./noctaliaPCWallpaper.jpg}";

  wallpaperState = {
    defaultWallpaper = "${config.programs.noctalia-shell.package}/share/noctalia-shell/Assets/Wallpaper/noctalia.png";
    usedRandomWallpapers = { };
    wallpapers = {
      HDMI-A-1 = {
        dark = wallpaperFile;
        light = wallpaperFile;
      };
    };
  };
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = substituteHome rawSettings;
  };

  # Сохраняем текущий noctalia state (выбранные обои) в ~/.cache/noctalia/wallpapers.json
  home.activation.copyNoctaliaWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.cache/noctalia"
    cp ${pkgs.writeText "noctalia-wallpapers.json" (builtins.toJSON wallpaperState)} \
      "${config.home.homeDirectory}/.cache/noctalia/wallpapers.json"
  '';

  # Запускаем noctalia-shell как user service внутри graphical session.
  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${config.programs.noctalia-shell.package}/bin/noctalia-shell";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
