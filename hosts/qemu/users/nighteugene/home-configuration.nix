{ flake, lib, ... }:

{
  imports = [
    flake.homeModules.default
    flake.homeModules.noctaliaPC
  ];

  # В QEMU используем тот же компактный курсор, что и на PC.
  home.pointerCursor.size = lib.mkForce 16;
}
