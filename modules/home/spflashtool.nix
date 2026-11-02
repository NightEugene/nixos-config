{
  inputs,
  pkgs,
  config,
  ...
}:

let
  # Тёмная тема SP Flash Tool 5/6. Парсер аргументов вендора отвергает
  # -stylesheet у Qt, поэтому QSS применяем через LD_PRELOAD-хук на
  # QApplication::exec() (src: spflashtool/theme.c).
  themeSo = pkgs.runCommand "spflashtool-theme" { nativeBuildInputs = [ pkgs.gcc ]; } ''
    gcc -shared -fPIC -O2 -o $out ${./spflashtool/theme.c} -ldl
  '';

  spflashPackages = inputs.tz-auto.packages.${pkgs.stdenv.hostPlatform.system};
  # Подменяем встроенный fetchGit на flake-input: источники попадают в lock
  # и не требуют SSH-доступа root во время nixos-rebuild.
  toolPackage =
    tool:
    (builtins.getAttr "spflashtool${tool}" spflashPackages).overrideAttrs (_: {
      src = inputs."spflashtool${tool}-src";
    });

  wrapper =
    tool:
    pkgs.writeShellScript "spflashtool${tool}" ''
      unset QT_STYLE_OVERRIDE QT_QPA_PLATFORMTHEME
      export SPFLASH_DARK_QSS="${config.home.homeDirectory}/.config/spflashtool/dark.qss"
      # QGtkStyle (Qt4) загружает GTK2 и движки тем через dlopen.
      export LD_LIBRARY_PATH="/run/opengl-driver/lib:/etc/profiles/per-user/nighteugene/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      export GTK_PATH="/etc/profiles/per-user/nighteugene/lib"
      export LD_PRELOAD="${themeSo}''${LD_PRELOAD:+:$LD_PRELOAD}"
      exec "${toolPackage tool}/bin/spflashtool${tool}" "$@"
    '';
in
{
  home.file = {
    ".config/spflashtool/dark.qss".source = ./spflashtool/dark.qss;
    "scripts/spflashtool5".source = wrapper "5";
    "scripts/spflashtool6".source = wrapper "6";
  };
}
