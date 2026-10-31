{ flake, lib, pkgs, ... }:

{
  imports = [
    flake.homeModules.default
    flake.homeModules.noctaliaPC
  ];

  # На десктопе курсор 24 пикселя выглядит слишком крупно.
  home.pointerCursor.size = lib.mkForce 16;

  # Десктоп pc: сюда можно добавить пакеты, специфичные для стационарного ПК.
  home.packages = with pkgs; [
    # Лаунчер игр; Blizzard Battle.net ставится из его каталога
    # (поиск "Battle.net" → Install, использует свой Wine-GE)
    lutris
  ];
}
