{ pkgs }:

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "codex";
  version = "0.160.0";

  src = pkgs.fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-package-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-T8xHq1f1L/dTY5Uah2EUbNEMgoi9hv7UVIfbsgSha3E=";
  };

  sourceRoot = ".";
  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    installShellFiles
  ];
  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    ncurses
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r bin codex-path codex-resources codex-package.json $out/
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/codex --version | grep -F "codex-cli ${finalAttrs.version}"
    runHook postInstallCheck
  '';

  meta = {
    inherit (pkgs.codex.meta) description homepage license;
    mainProgram = "codex";
    platforms = [ "x86_64-linux" ];
  };
})
