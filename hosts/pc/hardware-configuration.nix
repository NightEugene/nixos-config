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
    device = "/dev/disk/by-uuid/226cb0fc-f708-48f8-9863-af90490fe02f";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9BD8-B70C";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Windows + data + games разделы оставляем нетронутыми и монтируем только для доступа.
  # UUIDы root и boot актуальны для текущей NixOS-системы (проверены через `lsblk -f`).
  # uid=1000 делает файлы принадлежащими nighteugene, fmask/dmask задают права 644/755.
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/F2AA5D34AA5CF717";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "fmask=0133"
      "dmask=0022"
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
      "fmask=0133"
      "dmask=0022"
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
      "fmask=0133"
      "dmask=0022"
      "windows_names"
    ];
  };

  # Proton не может создавать symlinks на NTFS (/mnt/games).
  # Перенаправляем Steam compatdata на ext4 через bind mount.
  fileSystems."/mnt/games/SteamLibrary/steamapps/compatdata" = {
    device = "/home/nighteugene/.local/share/Steam/steamapps/compatdata";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Беспроводная сеть и Bluetooth зависят на firmware Intel AX211.
  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;

  # NVIDIA RTX 3060: проприетарный драйвер с modesetting для Wayland/niri.
  hardware.graphics.enable = true;
  # 32-bit библиотеки для Steam и Wine/Proton.
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    # Включено для корректного resume после гибернации:
    # драйвер сохраняет/восстанавливает видеопамять и состояние GPU.
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Сохранять видеопамять NVIDIA при suspend/hibernate.
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
}
