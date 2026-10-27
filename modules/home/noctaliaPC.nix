{ config, pkgs, inputs, lib, ... }:

let
  wallpaperFile = "${./noctaliaPCWallpaper.jpg}";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;
    settings = pkgs.replaceVars ./noctaliaCommon.toml {
      inherit wallpaperFile;
      # GPU-виджеты есть только на PC (NVIDIA); на laptop стат был бы "недоступен"
      gpuWidgets = ", \"gpu-vram\"";
      endWidgets = ''["tray", "notifications", "volume", "network", "bluetooth", "keyboard_layout", "control-center"]'';
      lockscreenWidgetName = "lockscreen-login-box@HDMI-A-1";
      lockscreenOutput = "HDMI-A-1";
      lockscreenCx = "1280.0";
      lockscreenCy = "961.0";
    };
  };

  # NVML (метрики GPU) подгружается через dlopen и не находится без
  # ld.so.cache на NixOS — подкладываем драйверный каталог сервису
  systemd.user.services.noctalia.Service.Environment = [ "LD_LIBRARY_PATH=/run/opengl-driver/lib" ];

  # Noctalia хранит runtime-настройки в ~/.local/state/noctalia/settings.toml
  # и применяет их поверх config.toml. Чтобы обои из конфига действительно
  # подхватились, прописываем путь к обоям и в state-файл.
  home.activation.setNoctaliaPCWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    stateFile="${config.home.homeDirectory}/.local/state/noctalia/settings.toml"
    if [ -f "$stateFile" ]; then
      ${pkgs.gnused}/bin/sed -i \
        -e '/^\[wallpaper\.default\]$/,/^\[/ s|^path = ".*"|path = "${wallpaperFile}"|' \
        -e '/^\[wallpaper\.last\]$/,/^\[/ s|^path = ".*"|path = "${wallpaperFile}"|' \
        "$stateFile"
    fi
    # Live-перечитывание settings.toml ломает сервис мониторинга — перезапускаем
    ${pkgs.systemd}/bin/systemctl --user restart noctalia 2>/dev/null || true
  '';
}
