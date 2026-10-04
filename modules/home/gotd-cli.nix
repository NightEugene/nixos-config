{ pkgs }:

pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gotd-cli";
  version = "0.11.0";

  # Official release binaries include the app credentials used by tg init.
  src = pkgs.fetchurl {
    url = "https://github.com/gotd/cli/releases/download/v${finalAttrs.version}/tg_${finalAttrs.version}_linux_amd64.tar.gz";
    hash = "sha256-NRD8ulWq3qLKG2MHZtN/ttujDEqySfnTrazGDKddQ8g=";
  };
  sourceRoot = ".";
  nativeBuildInputs = [ pkgs.installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -Dm755 tg $out/bin/tg
    installShellCompletion --cmd tg \
      --bash <($out/bin/tg completion bash) \
      --fish <($out/bin/tg completion fish) \
      --zsh <($out/bin/tg completion zsh)
    runHook postInstall
  '';

  meta = {
    description = "Telegram command-line utility from gotd/cli";
    homepage = "https://github.com/gotd/cli";
    license = pkgs.lib.licenses.mit;
    mainProgram = "tg";
    platforms = [ "x86_64-linux" ];
  };
})
