{ pkgs, ... }:

let
  fhsCommon = import ./fhs-common.nix { inherit pkgs; };

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

  # Актуальные проприетарные кодеки Chromium. Пакет vivaldi-ffmpeg-codecs
  # в nixpkgs слишком старый для текущего Yandex Browser, а nwjs несовместим по ABI.
  ffmpeg-plugin-browser =
    let
      src = pkgs.fetchurl {
        # В текущей сети HTTPS Snapcraft недоступен; содержимое закреплено хэшем.
        url = "http://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_118.snap";
        hash = "sha256-NYSbCLPCr2oxrVUokEC8g1BiZfIcQLaNKeMBkMNCsaI=";
      };
    in
    pkgs.runCommand "ffmpeg-plugin-browser" { nativeBuildInputs = [ pkgs.squashfsTools ]; } ''
      unsquashfs -dest . ${src} >/dev/null
      mkdir -p $out/lib/ffmpeg-plugin-browser
      install -Dm755 chromium-ffmpeg-git-2026-01-28/chromium-ffmpeg/libffmpeg.so \
        $out/lib/ffmpeg-plugin-browser/libffmpeg.so
    '';

  yandex-browser = pkgs.buildFHSEnv {
    name = "yandex-browser";

    targetPkgs =
      pkgs:
      [
        yandex-browser-unwrapped
        ffmpeg-plugin-browser
      ]
      ++ fhsCommon
      ++ (with pkgs; [
        ffmpeg
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav
      ]);

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
