{ pkgs }:

let
  # secretstorage нужен yt-dlp для расшифровки v11-cookies chromium-браузеров
  # через gnome-keyring (иначе сессионные куки не читаются).
  pythonEnv = pkgs.python3.withPackages (ps: [ ps.secretstorage ]);
in
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yt-dlp";
  version = "2026.08.19";

  # Standalone zipapp из GitHub releases — свежее, чем в nixpkgs.
  src = pkgs.fetchurl {
    url = "https://github.com/yt-dlp/yt-dlp/releases/download/${finalAttrs.version}/yt-dlp";
    hash = "sha256-H6ZzPDfqb7Ucma2P54Xnt+XzJGybmAIwMp1Pty7Y1NY=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/yt-dlp
    wrapProgram $out/bin/yt-dlp \
      --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.python3 ]} \
      --prefix PYTHONPATH : ${pythonEnv}/${pythonEnv.python.sitePackages}
    runHook postInstall
  '';

  meta.mainProgram = "yt-dlp";
})
