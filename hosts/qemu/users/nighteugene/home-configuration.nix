{ flake, lib, ... }:

{
  imports = [
    flake.homeModules.default
    flake.homeModules.noctaliaPC
  ];

  # В QEMU курсор 24 пикселя нормальный.
  home.pointerCursor.size = lib.mkForce 16;
}
