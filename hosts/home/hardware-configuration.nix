{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "r8169"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/13b4786b-75e7-4890-ac0e-09aa014d2717";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3317-C62E";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Windows + data + games разделы оставляем нетронутыми и монтируем только для доступа.
  # UUIDы взяты с текущей Ubuntu-системы, при установке NixOS могут не измениться,
  # но лучше перепроверить командой `lsblk -f` с Live-носителя.
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/F2AA5D34AA5CF717";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "windows_names"
    ];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/2C847AF7847AC2BE";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "windows_names"
    ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/943495133494FA06";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "windows_names"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Беспроводная сеть и Bluetooth зависят на firmware Intel AX211.
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;

  # NVIDIA RTX 3060: проприетарный драйвер с modesetting для Wayland/niri.
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
