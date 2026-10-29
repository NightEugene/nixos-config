{ pkgs }:

# Pi — минимальный терминальный coding-агент от Mario Zechner (pi.dev).
# npm-тарболл уже содержит собранный dist/, поэтому сборка не нужна;
# package-lock.json в тарболле нет — генерируем заранее и кладём рядом.
pkgs.buildNpmPackage rec {
  pname = "pi-coding-agent";
  version = "1.4.0";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
    hash = "sha256-0VXBbvb6AJYPv1iykRU26AsF8zcA4LFPvQiWft4MdCg=";
  };

  postPatch = ''
    cp ${./pi-package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-LBwaeQWq1Luy197UINLcmvSkOEvyIS/2VoHS2H+fIfQ=";

  # dist/ уже собран вендором; lifecycle-скрипты не нужны (--ignore-scripts в доках)
  dontNpmBuild = true;
  npmFlags = [ "--ignore-scripts" ];

  meta = {
    description = "Pi: minimal terminal coding agent harness";
    homepage = "https://pi.dev";
    mainProgram = "pi";
  };
}
