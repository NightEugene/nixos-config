{ pkgs, config, ... }:

let
  # Тёмная тема SP Flash Tool 5/6. Парсер аргументов вендора отвергает
  # -stylesheet у Qt, поэтому QSS применяем через LD_PRELOAD-хук на
  # QApplication::exec() (src: spflashtool/theme.c).
  themeSo = pkgs.runCommand "spflashtool-theme" { nativeBuildInputs = [ pkgs.gcc ]; } ''
    gcc -shared -fPIC -O2 -o $out ${./spflashtool/theme.c} -ldl
  '';

  wrapper = tool: pkgs.writeShellScript "spflashtool${tool}" ''
    unset QT_STYLE_OVERRIDE QT_QPA_PLATFORMTHEME
    export SPFLASH_DARK_QSS="${config.home.homeDirectory}/.config/spflashtool/dark.qss"
    export LD_PRELOAD="${themeSo}''${LD_PRELOAD:+:$LD_PRELOAD}"
    exec "${config.home.homeDirectory}/.nix-profile/bin/spflashtool${tool}" "$@"
  '';
in
{
  home.file = {
    ".config/spflashtool/dark.qss".source = ./spflashtool/dark.qss;
    "scripts/spflashtool5".source = wrapper "5";
    "scripts/spflashtool6".source = wrapper "6";
  };
}
