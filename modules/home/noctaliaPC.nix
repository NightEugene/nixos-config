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
    settings = ./noctaliaPC.toml;
  };

  # Сохраняем текущий noctalia state (выбранные обои) в ~/.cache/noctalia/wallpapers.json
  home.activation.copyNoctaliaWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.cache/noctalia"
    cat > "${config.home.homeDirectory}/.cache/noctalia/wallpapers.json" <<'EOF'
    {
      "defaultWallpaper": "${config.programs.noctalia.package}/share/noctalia-shell/Assets/Wallpaper/noctalia.png",
      "usedRandomWallpapers": {},
      "wallpapers": {
        "HDMI-A-1": {
          "dark": "${wallpaperFile}",
          "light": "${wallpaperFile}"
        }
      }
    }
    EOF
  '';
}
