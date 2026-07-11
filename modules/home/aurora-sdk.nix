{ pkgs, ... }:

let
  fhsCommon = import ./fhs-common.nix { inherit pkgs; };

  version = "5.2.1.200";
  installerName = "AuroraSDK-${version}-BT-release-linux-64-offline-26.06.17-08.08.07.run";

  aurora-sdk-unwrapped = pkgs.stdenvNoCC.mkDerivation {
    pname = "aurora-sdk-unwrapped";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://sdk-repo.omprussia.ru/sdk/installers/5.2.1/${version}-release/AuroraSDK-BT/${installerName}";
      sha256 = "1242k1mr1786k2190yvdfyl5ap7f1s057d1j3mjqbpcs1qvhvbxw";
    };

    installPhase = ''
      mkdir -p $out/share/aurora-sdk
      cp $src $out/share/aurora-sdk/${installerName}
      chmod +x $out/share/aurora-sdk/${installerName}
    '';

    dontUnpack = true;
    dontFixup = true;
    dontStrip = true;

    meta = {
      description = "Aurora SDK BT ${version} offline installer";
      homepage = "https://developer.auroraos.ru";
      license = pkgs.lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };

  aurora-sdk-runner = pkgs.writeShellScriptBin "aurora-sdk-runner" ''
    if [ -z "''${AURORA_SDK_DIR:-}" ]; then
      echo "AURORA_SDK_DIR is not set" >&2
      exit 1
    fi

    if [ ! -x "$AURORA_SDK_DIR/bin/qtcreator" ]; then
      if ! command -v docker >/dev/null 2>&1; then
        echo "Docker is required to install Aurora SDK BT." >&2
        echo "Please enable Docker on your NixOS system and try again." >&2
        exit 1
      fi

      if ! docker info >/dev/null 2>&1; then
        echo "Docker daemon is not running or not accessible." >&2
        echo "Please start Docker and try again." >&2
        exit 1
      fi

      echo "Installing Aurora SDK BT ${version} into $AURORA_SDK_DIR..."
      if [ -d "$AURORA_SDK_DIR" ]; then
        rm -rf "$AURORA_SDK_DIR"
      fi
      mkdir -p "$AURORA_SDK_DIR" "''${AURORA_WORKSPACE_DIR:-$HOME/AuroraWorkspace}"

      export INSTALL_HOME="$AURORA_SDK_DIR/.install-home"
      mkdir -p "$INSTALL_HOME"
      export HOME="$INSTALL_HOME"
      export QT_QPA_PLATFORM=minimal

      ${aurora-sdk-unwrapped}/share/aurora-sdk/${installerName} \
        --no-size-checking \
        "non-interactive=true" \
        "accept-licenses=true" \
        "TargetDir=$AURORA_SDK_DIR" \
        "workspaceDir=''${AURORA_WORKSPACE_DIR:-$HOME/AuroraWorkspace}"

      rm -rf "$INSTALL_HOME"

      if [ ! -x "$AURORA_SDK_DIR/bin/qtcreator" ]; then
        echo "Aurora SDK BT installation failed or was incomplete." >&2
        echo "Check that Docker is running and has enough free disk space, then try again." >&2
        exit 1
      fi

      echo "Aurora SDK BT installed."
    fi

    export QT_QPA_PLATFORM=xcb
    exec "$AURORA_SDK_DIR/bin/qtcreator" "$@"
  '';

  aurora-sdk-fhs = pkgs.buildFHSEnv {
    name = "aurora-sdk-fhs";

    extraBwrapArgs = [
      "--bind-try /run/docker.sock /run/docker.sock"
      "--bind-try /var/run/docker.sock /var/run/docker.sock"
    ];

    targetPkgs = pkgs:
      fhsCommon
      ++ (with pkgs; [
        harfbuzz
        brotli.lib
        docker

        # GStreamer libraries required by the EmulationManagement plugin
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav

        # QEMU emulator dependencies
        util-linux
      ]);

    runScript = "${aurora-sdk-runner}/bin/aurora-sdk-runner";
  };

  aurora-sdk = pkgs.stdenvNoCC.mkDerivation {
    pname = "aurora-sdk";
    inherit version;

    dontUnpack = true;
    dontFixup = true;
    dontStrip = true;

    nativeBuildInputs = [ pkgs.librsvg ];

    installPhase = ''
      mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/512x512/apps

      install -Dm755 ${launcher} $out/bin/aurora-sdk
      rsvg-convert -w 512 -h 512 ${./aurora-sdk-icon.svg} \
        -o $out/share/icons/hicolor/512x512/apps/aurora-sdk.png

      cat > $out/share/applications/aurora-sdk.desktop <<EOF
[Desktop Entry]
Name=Aurora SDK
Comment=Aurora SDK BT ${version} IDE
Exec=aurora-sdk
Type=Application
Terminal=false
Icon=$out/share/icons/hicolor/512x512/apps/aurora-sdk.png
Categories=Development;IDE;
EOF
    '';

    meta = {
      description = "Aurora SDK BT ${version}";
      homepage = "https://developer.auroraos.ru";
      license = pkgs.lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };

  launcher = pkgs.writeShellScript "aurora-sdk-launcher" ''
    export AURORA_SDK_DIR="''${AURORA_SDK_DIR:-$HOME/.local/share/aurora-sdk}"
    export AURORA_WORKSPACE_DIR="''${AURORA_WORKSPACE_DIR:-$HOME/AuroraWorkspace}"
    exec ${aurora-sdk-fhs}/bin/aurora-sdk-fhs "$@"
  '';
in
{
  home.packages = [ aurora-sdk ];
}
