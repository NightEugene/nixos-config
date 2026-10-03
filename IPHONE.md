# iPhone и Flutter на NixOS

На хосте `laptop` установлены Flutter, libimobiledevice, ideviceinstaller,
ifuse; включён usbmuxd для связи с iPhone/iPad по USB.
Это инструменты разработки Flutter, подключения телефона и установки
уже подписанного приложения. Сборка Flutter для iOS требует macOS и Xcode.

## Подключение

Подключите разблокированный iPhone кабелем и подтвердите «Доверять».

```sh
systemctl status usbmuxd
idevice_id -l
idevicepair pair
idevicepair validate
ideviceinfo -k ProductVersion
```

При нескольких устройствах укажите UDID через `-u`.
Первое сопряжение может потребовать повторить команду после подтверждения
на телефоне. Не публикуйте UDID и записи сопряжения.

## Режим разработчика

На iPhone: Настройки → Конфиденциальность и безопасность → Режим
разработчика. Включите переключатель, перезагрузите телефон, затем
подтвердите включение и введите код-пароль.
После сопряжения можно проверить статус и показать пункт настроек с Linux:

```sh
idevicedevmodectl list
idevicedevmodectl reveal
```

На подключённом iPhone с iOS 26.5 команда `reveal` успешно показала меню.
Включение подтвердите на самом телефоне. Поддержка этих команд зависит от
версии iOS; альтернативы — сопряжение с Xcode на Mac или установка приложения
с разработческой подписью.

[Разъяснение Apple](https://developer.apple.com/videos/play/wwdc2022/110344/).

## Установка готовой сборки

IPA должен быть подписан для этого устройства: действительный сертификат,
профиль и регистрация UDID, если этого требует способ распространения.
Для разработческой сборки включите режим разработчика на iPhone.

```sh
ideviceinstaller -i /path/to/Likuner.ipa
ideviceinstaller -l
idevicesyslog
```

Для новых версий iOS возможности диагностики и запуска зависят от поддержки
протоколов libimobiledevice. Наличие USB-инструментов не заменяет Xcode,
его отладчик или iOS Simulator. `flutter devices` на Linux не означает
поддержку локальной сборки и отладки Flutter для iOS.

## Доступ к файлам

```sh
mkdir -p "$HOME/mnt/iphone"
ifuse "$HOME/mnt/iphone"
# После работы:
fusermount -u "$HOME/mnt/iphone"
```

Доступ ограничен файлами, которые iOS предоставляет через AFC.

## Сборка на Mac

Установить Flutter и Xcode, настроить подпись Runner в Xcode, затем:

```sh
flutter pub get
flutter doctor -v
flutter run -d <iphone-udid>
# Для выбранного способа распространения, после настройки подписи:
flutter build ipa
```

- [Настройка Flutter для iOS](https://docs.flutter.dev/platform-integration/ios/setup)
- [Сборка и распространение iOS](https://docs.flutter.dev/deployment/ios)
- [libimobiledevice](https://libimobiledevice.org/)

## Проверка установки, 3 октября 2026

`nixos-rebuild switch --offline --flake .#laptop` завершился успешно.
`usbmuxd` активен; USB-сопряжение проверено через `idevicepair validate`.
Подключённое устройство: ProductType `iPhone16,2`, iOS 26.5.
Flutter 3.44.4 / Dart 3.12.2 доступны в PATH.
Перезагрузка NixOS и повторный вход в сессию для этих инструментов не нужны.
