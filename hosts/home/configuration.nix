{
  inputs,
  flake,
  lib,
  ...
}:

{
  imports = [
    # Для home disk-config.nix НЕ импортируется автоматически,
    # так как он требует ручного применения при установке.
    # inputs.disko.nixosModules.disko
    flake.nixosModules.default

    ./boot.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "home";

  # Swap-файл на корневом разделе, аналогично laptop.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16GB in MB
    }
  ];

  # Десктоп: нет нужды в мобильных сервисах вроде upower/auto-cpufreq.
  services.auto-cpufreq.enable = lib.mkForce false;
  services.upower.enable = lib.mkForce false;
  services.thermald.enable = lib.mkForce false;
}
