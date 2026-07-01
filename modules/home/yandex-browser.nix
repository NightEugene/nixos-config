{ pkgs, ... }:

let
  yandex-browser-unwrapped = pkgs.stdenvNoCC.mkDerivation {
    pname = "yandex-browser-unwrapped";
    version = "26.4.1.1110-1";

    src = pkgs.fetchurl {
      url = "https://repo.yandex.ru/yandex-browser/deb/pool/main/y/yandex-browser-stable/yandex-browser-stable_26.4.1.1110-1_amd64.deb";
      sha256 = "1fn8abck5vcqr75sji5na3hj3g7grj54xaja61sv9qd5d065gj17";
    };

    nativeBuildInputs = [ pkgs.dpkg ];

    unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions";

    installPhase = ''
      mkdir -p $out/share
      cp -r opt/yandex/browser $out/
      cp -r usr/share/applications $out/share/
      cp -r usr/share/icons $out/share/
    '';

    dontFixup = true;
    dontPatchELF = true;
    dontStrip = true;
  };

  yandex-browser = pkgs.buildFHSEnv {
    name = "yandex-browser";

    targetPkgs = pkgs: with pkgs; [
      yandex-browser-unwrapped

      glibc
      libgcc
      gcc.cc.lib
      zlib
      expat
      dbus
      fontconfig
      freetype
      libglvnd
      libpulseaudio
      alsa-lib
      pipewire
      openssl
      nss
      nspr
      cups
      libgbm
      libdrm
      mesa

      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXi
      libXinerama
      libXcursor
      libXrender
      libXScrnSaver
      libXrandr
      libXxf86vm
      libxcb
      xcbutil
      xcbutilcursor
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      xcbutilwm
      libxkbfile
      libxshmfence

      systemd
      xdg-utils
      libnotify
      libappindicator-gtk3
      gtk3
      at-spi2-core
      pango
      cairo
      gdk-pixbuf
      glib

      libsecret
      libxkbcommon
      libXtst
      libSM
      libICE
      libgcrypt

      ffmpeg
    ];

    runScript = "${yandex-browser-unwrapped}/browser/yandex-browser";

    extraInstallCommands = ''
      install -Dm644 ${yandex-browser-unwrapped}/share/applications/yandex-browser.desktop $out/share/applications/yandex-browser.desktop
      sed -i 's|/usr/bin/yandex-browser-stable|yandex-browser|g' $out/share/applications/yandex-browser.desktop
      sed -i '/DBusActivatable=true/d' $out/share/applications/yandex-browser.desktop
      install -Dm644 ${yandex-browser-unwrapped}/browser/product_logo_256.png $out/share/icons/hicolor/256x256/apps/yandex-browser.png
    '';

    meta = {
      description = "Yandex Browser";
      homepage = "https://browser.yandex.ru";
      license = pkgs.lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  home.packages = [ yandex-browser ];
}
