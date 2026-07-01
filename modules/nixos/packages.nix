{ pkgs, ... }:

let
  max-unwrapped = pkgs.stdenvNoCC.mkDerivation {
    pname = "max-unwrapped";
    version = "26.21.0.73284";

    src = pkgs.fetchurl {
      url = "https://download.max.ru/linux/deb/pool/main/m/max/MAX-26.21.0.73284.deb";
      sha256 = "1fcfbf4e312b4e9bdcfa099ba48de9880543d08334bc7e69be10036b36134952";
    };

    nativeBuildInputs = [ pkgs.dpkg ];

    unpackPhase = "dpkg-deb -x $src .";

    installPhase = ''
      mkdir -p $out/share
      cp -r usr/share/max/* $out/
      cp -r usr/share/applications $out/share/
      cp -r usr/share/icons $out/share/
      cp -r usr/share/pixmaps $out/share/
    '';

    dontFixup = true;
    dontPatchELF = true;
    dontStrip = true;
  };

  max = pkgs.buildFHSEnv {
    name = "max";

    targetPkgs = pkgs: with pkgs; [
      max-unwrapped

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
      libXrandr
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

      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtwebengine
      qt6.qtmultimedia
      qt6.qtwayland

      libsecret
      libxkbcommon
      libXtst
      libSM
      libICE
      libgcrypt
    ];

    runScript = "${max-unwrapped}/bin/max";

    extraInstallCommands = ''
      install -Dm644 ${max-unwrapped}/share/applications/max.desktop $out/share/applications/max.desktop
      install -Dm644 ${max-unwrapped}/share/icons/hicolor/512x512/apps/max.png $out/share/icons/hicolor/512x512/apps/max.png
    '';

    meta = {
      description = "MAX messenger";
      homepage = "https://max.ru";
      license = pkgs.lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    wget
    parted
    nixfmt
    nixfmt-tree
    cachix
    telegram-desktop
    mattermost-desktop
    max
    gcc
    gdb
    gnumake
    eog
  ];
}
