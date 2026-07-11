{ flake, lib, ... }:

{
  imports = [
    flake.homeModules.default
    flake.homeModules.noctaliaHome
  ];

  # На десктопе курсор 24 пикселя выглядит слишком крупно.
  home.pointerCursor.size = lib.mkForce 16;

  # Десктоп home: сюда можно добавить пакеты, специфичные для стационарного ПК.
  # Пример: home.packages = with pkgs; [ steam ];
}
