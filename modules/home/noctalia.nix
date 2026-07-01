{ config, pkgs, inputs, lib, ... }:

let
  rawSettings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;

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
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = substituteHome rawSettings;
  };
}
