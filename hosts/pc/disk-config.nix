# Этот файл НЕ импортируется в configuration.nix автоматически.
# Он описывает целевую разметку диска nvme0n1 для установки NixOS
# с сохранением существующих Windows-разделов на sda и games-раздела на nvme0n1p2.
#
# Перед применением:
# 1. Загрузиться с NixOS ISO.
# 2. Вручную отформатировать nvme0n1p4 в ext4 (сюда будет ставиться NixOS).
# 3. Смонтировать /mnt /mnt/boot.
# 4. Установить NixOS любым удобным способом (nixos-install / disko --mode mount).
#
# Если вы хотите использовать disko для форматирования, раскомментируйте
# блок ниже и примените его с Live-носителя, предварительно убедившись,
# что границы разделов совпадают с текущими (см. `parted /dev/nvme0n1 unit s print`).

{ ... }:

{
  # Пример конфигурации disko только для NixOS-разделов.
  # ВНИМАНИЕ: не запускайте `disko --mode format` на работающей Ubuntu,
  # это уничтожит данные на nvme0n1p4.
  #
  # disko.devices = {
  #   disk = {
  #     nvme = {
  #       type = "disk";
  #       device = "/dev/nvme0n1";
  #       content = {
  #         type = "gpt";
  #         partitions = {
  #           # Microsoft reserved partition (сохраняем)
  #           msftres = {
  #             start = "34s";
  #             end = "32767s";
  #             type = "E3C9E316-0B5C-4DB8-817D-F92DF00215AE";
  #           };
  #           # games (NTFS, сохраняем)
  #           games = {
  #             start = "32768s";
  #             end = "3842195455s";
  #             type = "EBD0A0A2-B9E5-4433-87C0-68B6B72699C7";
  #           };
  #           # EFI system partition (сохраняем, только форматируем в vfat при необходимости)
  #           ESP = {
  #             start = "3842195456s";
  #             end = "3844397055s";
  #             type = "EF00";
  #             content = {
  #               type = "filesystem";
  #               format = "vfat";
  #               mountpoint = "/boot";
  #               mountOptions = [ "umask=0077" ];
  #             };
  #           };
  #           # NixOS root (заменяет Ubuntu root)
  #           root = {
  #             start = "3844397056s";
  #             end = "100%";
  #             content = {
  #               type = "filesystem";
  #               format = "ext4";
  #               mountpoint = "/";
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
}
