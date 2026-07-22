{
  inputs,
  flake,
  lib,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    flake.nixosModules.default

    ./boot.nix
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  # Swap-файл для QEMU (16 ГиБ, как на laptop).
  my.swapFile = {
    enable = true;
    sizeMiB = 16 * 1024;
  };

  # QEMU: нет нужды в мобильных сервисах и NVIDIA.
  services.auto-cpufreq.enable = lib.mkForce false;
  services.upower.enable = lib.mkForce false;
  services.thermald.enable = lib.mkForce false;

  # Для QEMU не нужна кастомная тема GRUB с высоким разрешением.
  boot.loader.grub.gfxmodeBios = lib.mkForce "1024x768";
}
