{ pkgs }:

with pkgs; [
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
]
