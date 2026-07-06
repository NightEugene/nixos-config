# Установка NixOS на ПК `home`

Эта инструкция описывает установку NixOS на стационарный ПК `home`, заменяя существующую Ubuntu на `nvme0n1p4`, с сохранением Windows и data-разделов.

## Аппаратная конфигурация

- Материнская плата: Gigabyte B760M DS3H AX DDR4 (UEFI)
- CPU: Intel Core i5-12400F
- GPU: NVIDIA GeForce RTX 3060
- RAM: 16 GB
- Диски:
  - `nvme0n1` 4 TB Kingston:
    - `nvme0n1p1` — Microsoft reserved partition (сохраняем)
    - `nvme0n1p2` — `games` (NTFS, сохраняем)
    - `nvme0n1p3` — EFI system partition (используем для `/boot`)
    - `nvme0n1p4` — Ubuntu root ext4 (заменяем на NixOS root)
  - `sda` 1 TB WD:
    - `sda1` — восстановление Windows (сохраняем)
    - `sda2` — EFI Windows (сохраняем)
    - `sda3` — MSR (сохраняем)
    - `sda4` — Windows C: (NTFS, сохраняем)
    - `sda5` — Windows recovery (NTFS, сохраняем)
    - `sda6` — `data` (NTFS, сохраняем)

## Подготовка

1. **Сделать резервную копию важных данных** с `nvme0n1p2` (`games`) и `sda6` (`data`).
   Хотя инструкция предполагает сохранение этих разделов, любая ошибка при разметке может их уничтожить.

2. **Создать загрузочную флешку** с NixOS GNOME или Plasma ISO:
   <https://nixos.org/download/>

3. **Загрузиться с флешки в режиме UEFI** (не Legacy/CSM).

## Загрузка с Live-носителя

1. Выбрать в UEFI boot menu флешку с NixOS.
2. Дождаться загрузки Live-окружения.
3. Открыть терминал.

## Подключение к сети

Если используется WiFi:

```bash
nmcli device wifi list
nmcli device wifi connect "SSID" password "PASSWORD"
```

Проверка:

```bash
ping -c 3 1.1.1.1
```

## Проверка текущей разметки

Убедиться, что разделы совпадают с описанными в конфиге:

```bash
lsblk -f
sudo parted /dev/nvme0n1 unit s print
```

Если размеры/границы разделов отличаются от тех, что указаны в `hosts/home/disk-config.nix`, перед продолжением нужно обновить `disk-config.nix` и `hardware-configuration.nix`.

## Форматирование root-раздела

> ВНИМАНИЕ: следующая команда уничтожит все данные на `nvme0n1p4` (текущую Ubuntu).

```bash
sudo mkfs.ext4 -L nixos /dev/nvme0n1p4
```

## Подготовка EFI-раздела

EFI-раздел `nvme0n1p3` уже отформатирован в vfat. Можно либо использовать его как есть, либо переформатировать (безопасно, так как там только загрузчик Ubuntu, который больше не нужен):

```bash
# Переформатирование EFI (опционально)
sudo mkfs.vfat -F 32 -n boot /dev/nvme0n1p3
```

Если EFI не переформатировать, убедиться, что на нём достаточно места (не менее 100 MB свободно).

## Монтирование разделов

```bash
sudo mkdir -p /mnt
sudo mount /dev/disk/by-label/nixos /mnt

sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p3 /mnt/boot
```

## Клонирование репозитория конфигурации

```bash
sudo mkdir -p /mnt/etc/nixos
cd /mnt/etc/nixos
sudo git clone https://github.com/NightEugene/nixos-config.git .
sudo git checkout master
```

## Обновление UUID в конфигурации

После форматирования `nvme0n1p4` его UUID изменился. Получить новые UUID:

```bash
lsblk -f /dev/nvme0n1
```

Открыть `hosts/home/hardware-configuration.nix` и заменить UUID для `/` на новый:

```nix
fileSystems."/" = {
  device = "/dev/disk/by-uuid/НОВЫЙ-UUID-ROOT";
  fsType = "ext4";
};
```

Если EFI-раздел переформатировался, также обновить UUID для `/boot`.

Если UUID не изменились (например, использовалась метка `/dev/disk/by-label/nixos`), можно оставить как есть.

## Установка NixOS

```bash
cd /mnt/etc/nixos
sudo nixos-install --flake .#home --no-channel-copy
```

Пароль root будет запрошен в процессе установки.

## Настройка загрузчика

GRUB устанавливается автоматически через конфиг `hosts/home/boot.nix`. `os-prober` должен обнаружить Windows на `sda`.

Если после установки Windows не появляется в меню GRUB:

1. Загрузиться в NixOS.
2. Проверить, что `sda` доступен:
   ```bash
   sudo os-prober
   ```
3. Пересобрать конфигурацию:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#home
   ```

## Первый вход

После установки:

```bash
reboot
```

При первой загрузке:

1. В меню GRUB выбрать NixOS.
2. Войти как пользователь `nighteugene` (пароль, заданный при установке).

## Применение конфигурации после установки

После входа в систему:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#home
```

Или, если настроен `just`:

```bash
just switch
```

> На этапе первой установки `just` может быть недоступен, используйте `nixos-rebuild`.

## Проверка NVIDIA

После первого входа проверить, что NVIDIA драйвер загружен:

```bash
nvidia-smi
```

Если Wayland/niri не запускается, возможно потребуется отключить `hardware.nvidia.modesetting.enable` или переключиться на `open` драйвер в `hosts/home/hardware-configuration.nix`.

## Проверка NTFS-разделов

Разделы должны автоматически монтироваться в:

- `/mnt/windows` — Windows (`sda4`)
- `/mnt/data` — data (`sda6`)
- `/mnt/games` — games (`nvme0n1p2`)

Проверка:

```bash
mount | grep /mnt
ls -la /mnt/data
```

## Восстановление Windows в меню загрузки

Если GRUB не обнаружил Windows:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#home
```

Или загрузить Windows через UEFI boot menu (обычно F12 при старте).

## Если установка не удалась

1. Не перезагружаться.
2. Собрать логи:
   ```bash
   journalctl -xe > /tmp/install.log
   ```
3. Проверить разметку:
   ```bash
   lsblk -f
   sudo parted /dev/nvme0n1 print
   ```
4. Проверить конфигурацию:
   ```bash
   sudo nixos-install --flake /mnt/etc/nixos#home --show-trace 2>&1 | tee /tmp/nixos-install.log
   ```
