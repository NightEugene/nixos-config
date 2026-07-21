{ pkgs, ... }:

let
  fhsCommon = import ./fhs-common.nix { inherit pkgs; };

  version = "0.2.3";

  rto-proxy-appimage = pkgs.fetchurl {
    url = "https://github.com/RutrackerOrg/rutracker-proxy/releases/download/v${version}/rto-proxy-${version}-x86_64.AppImage";
    hash = "sha256-//UGtbJ6scBVVyfLxdxJZiUJbDpgrooov4uJZLX7s/0=";
  };

  rto-proxy-extracted = pkgs.appimageTools.extract {
    pname = "rto-proxy";
    inherit version;
    src = rto-proxy-appimage;
  };

  # Старые библиотеки для совместимости с Electron 1.x (2017)
  old-libs = {
    harfbuzz = pkgs.fetchurl {
      url = "http://security.ubuntu.com/ubuntu/pool/main/h/harfbuzz/libharfbuzz0b_1.0.1-1ubuntu0.1_amd64.deb";
      hash = "sha256-UcEXUzoIK3HlnVrFKF7FeEB+oGewnn9zG7Vi+nDGBUA=";
    };
    graphite2 = pkgs.fetchurl {
      url = "http://security.ubuntu.com/ubuntu/pool/main/g/graphite2/libgraphite2-3_1.3.10-0ubuntu0.16.04.1_amd64.deb";
      hash = "sha256-2+3XEN7uI7H5DqdCZ06sxqT8lXHcSrM5iyBlgZ4s/Qc=";
    };
    pango = pkgs.fetchurl {
      url = "http://security.ubuntu.com/ubuntu/pool/main/p/pango1.0/libpango-1.0-0_1.40.14-1ubuntu0.1_amd64.deb";
      hash = "sha256-u+YFkEew4DQzruNYsB0SyNwINTL72BYElK653HTzo9k=";
    };
    pangoft2 = pkgs.fetchurl {
      url = "http://security.ubuntu.com/ubuntu/pool/main/p/pango1.0/libpangoft2-1.0-0_1.40.14-1ubuntu0.1_amd64.deb";
      hash = "sha256-5ksFxRCOUBdFlVKIoZSSh28r+8f1RJf9a4eue4siOOs=";
    };
    pangocairo = pkgs.fetchurl {
      url = "http://security.ubuntu.com/ubuntu/pool/main/p/pango1.0/libpangocairo-1.0-0_1.40.14-1ubuntu0.1_amd64.deb";
      hash = "sha256-yw8nOyrm91KqjSla7bOOtIIM/8LAx/wlvDQeyLGCkwo=";
    };
    libthai = pkgs.fetchurl {
      url = "http://security.ubuntu.com/ubuntu/pool/main/libt/libthai/libthai0_0.1.27-2_amd64.deb";
      hash = "sha256-iALHy3v6D9ptiZ8cuYjbqQ/hw7gksU/Ygt4T3idbyKU=";
    };
    libdatrie = pkgs.fetchurl {
      url = "http://security.ubuntu.com/ubuntu/pool/main/libd/libdatrie/libdatrie1_0.2.10-7_amd64.deb";
      hash = "sha256-p54WjeUTvYyotM9i4VVzL93Fr1JRH3eJ1K1+EBkluBM=";
    };
  };

  old-libs-extracted = pkgs.runCommand "old-libs-extracted" { nativeBuildInputs = [ pkgs.binutils ]; } (
    builtins.concatStringsSep "\n" (
      pkgs.lib.mapAttrsToList (name: deb: ''
        mkdir -p $out/${name}
        cd $out/${name}
        ar -x ${deb}
        tar xf data.tar.xz
      '') old-libs
    )
  );

  # Патчим app.asar: добавляем фиктивный electron-updater и electron-is-dev
  rto-proxy-unwrapped = pkgs.runCommand "rto-proxy-unwrapped" { nativeBuildInputs = [ pkgs.asar pkgs.gnused ]; src = rto-proxy-extracted; } ''
    mkdir -p $out/opt/rto-proxy
    cp -r $src/* $out/opt/rto-proxy/
    chmod -R u+w $out/opt/rto-proxy

    # Извлекаем app.asar, добавляем electron-updater и electron-is-dev
    asar extract $out/opt/rto-proxy/usr/bin/resources/app.asar /tmp/rto-app

    mkdir -p /tmp/rto-app/node_modules/electron-updater
    cat > /tmp/rto-app/node_modules/electron-updater/index.js <<'EOF'
module.exports = {
  autoUpdater: {
    checkForUpdates: () => {},
    on: () => {},
    quitAndInstall: () => {}
  }
};
EOF
    cat > /tmp/rto-app/node_modules/electron-updater/package.json <<'EOF'
{
  "name": "electron-updater",
  "version": "1.0.0",
  "main": "index.js"
}
EOF

    mkdir -p /tmp/rto-app/node_modules/electron-is-dev
    cat > /tmp/rto-app/node_modules/electron-is-dev/index.js <<'EOF'
module.exports = false;
EOF
    cat > /tmp/rto-app/node_modules/electron-is-dev/package.json <<'EOF'
{
  "name": "electron-is-dev",
  "version": "1.0.0",
  "main": "index.js"
}
EOF

    asar pack /tmp/rto-app $out/opt/rto-proxy/usr/bin/resources/app.asar
  '';

  old-libs-path = builtins.concatStringsSep ":" (
    pkgs.lib.mapAttrsToList (name: _: "${old-libs-extracted}/${name}/usr/lib/x86_64-linux-gnu") old-libs
  );

  rto-proxy = pkgs.buildFHSEnv {
    name = "rto-proxy";

    targetPkgs = pkgs: [
      rto-proxy-unwrapped
    ]
    ++ fhsCommon
    ++ (with pkgs; [
      gtk2
      atk
      gdk-pixbuf
      pango
      cairo
      gnome2.GConf
    ]);

    runScript = pkgs.writeShellScript "rto-proxy-wrapper" ''
      export LD_LIBRARY_PATH="${old-libs-path}:$LD_LIBRARY_PATH"
      exec ${rto-proxy-unwrapped}/opt/rto-proxy/usr/bin/rto-proxy "$@"
    '';

    meta = {
      description = "RuTracker proxy based on Electron";
      homepage = "https://github.com/RutrackerOrg/rutracker-proxy";
      license = pkgs.lib.licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  home.packages = [ rto-proxy ];
}
