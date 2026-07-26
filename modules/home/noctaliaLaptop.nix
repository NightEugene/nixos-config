{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

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
    settings = pkgs.replaceVars ./noctaliaLaptop.toml {
      inherit wallpaperFile;
    };
  };

  # Noctalia хранит runtime-настройки в ~/.local/state/noctalia/settings.toml
  # и применяет их поверх config.toml. Чтобы обои из конфига действительно
  # подхватились на ноутбуке, прописываем путь к обоям и в state-файл.
  home.activation.setNoctaliaLaptopWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    stateFile="${config.home.homeDirectory}/.local/state/noctalia/settings.toml"
    if [ -f "$stateFile" ]; then
      ${pkgs.gnused}/bin/sed -i \
        -e '/^\[wallpaper\.default\]$/,/^\[/ s|^path = ".*"|path = "${wallpaperFile}"|' \
        -e '/^\[wallpaper\.last\]$/,/^\[/ s|^path = ".*"|path = "${wallpaperFile}"|' \
        "$stateFile"
    fi
  '';
}
