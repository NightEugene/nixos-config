{ flake, lib, ... }:

{
  imports = [
    flake.homeModules.default
    flake.homeModules.noctaliaPC
  ];

  # На десктопе курсор 24 пикселя выглядит слишком крупно.
  home.pointerCursor.size = lib.mkForce 16;

  # Десктоп pc: сюда можно добавить пакеты, специфичные для стационарного ПК.
  # Пример: home.packages = with pkgs; [ steam ];
}
