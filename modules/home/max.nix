{ pkgs, ... }:

let
  fhsCommon = import ./fhs-common.nix { inherit pkgs; };

  max-unwrapped = pkgs.stdenvNoCC.mkDerivation {
    pname = "max-unwrapped";
    version = "26.34.0.79863";

    src = pkgs.fetchurl {
      url = "https://download.max.ru/linux/deb/pool/main/m/max/MAX-26.34.0.79863.deb";
      sha256 = "5514c9505d7025e26c4f085bb8b6cc7f2539c05242e4e04b41967d373a5d6663";
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

    targetPkgs = pkgs: [
      max-unwrapped
    ]
    ++ fhsCommon
    ++ (with pkgs; [
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtwebengine
      qt6.qtmultimedia
      qt6.qtwayland
    ]);

    runScript = "${max-unwrapped}/bin/max";

    extraInstallCommands = ''
      install -Dm644 ${max-unwrapped}/share/applications/max.desktop $out/share/applications/max.desktop
      sed -i 's|Exec=/usr/share/max/bin/max|Exec=max|' $out/share/applications/max.desktop
      sed -i 's|Icon=/usr/share/pixmaps/max.png|Icon=max|' $out/share/applications/max.desktop
      sed -i '/DBusActivatable=true/d' $out/share/applications/max.desktop
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
  home.packages = [ max ];
}
