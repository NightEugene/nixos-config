{ flake, ... }:

{
  imports = [
    flake.homeModules.default
    flake.homeModules.noctaliaHome
  ];

  # Десктоп home: сюда можно добавить пакеты, специфичные для стационарного ПК.
  # Пример: home.packages = with pkgs; [ steam ];
}
