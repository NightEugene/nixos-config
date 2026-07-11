{
  inputs,
  flake,
  lib,
  ...
}:

{
  imports = [
    # Для pc disk-config.nix НЕ импортируется автоматически,
    # так как он требует ручного применения при установке.
    # inputs.disko.nixosModules.disko
    flake.nixosModules.default

    ./boot.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "pc";

  # Swap-файл на корневом разделе, аналогично laptop.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB in MB
    }
  ];

  # Гибернация: resume в swap-файл на корневом разделе.
  # resume_offset = первый physical_offset из `filefrag -v /var/lib/swapfile`.
  # Если swap-файл пересоздаётся, offset нужно обновить.
  boot.resumeDevice = "/dev/disk/by-uuid/226cb0fc-f708-48f8-9863-af90490fe02f";
  boot.kernelParams = [ "resume_offset=462327808" ];

  # Десктоп: нет нужды в мобильных сервисах вроде upower/auto-cpufreq.
  services.auto-cpufreq.enable = lib.mkForce false;
  services.upower.enable = lib.mkForce false;
  services.thermald.enable = lib.mkForce false;
}
