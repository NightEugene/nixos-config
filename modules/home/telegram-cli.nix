{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "telegram-cli";
  version = "1.4.1-unstable-2016-03-23";

  src = pkgs.fetchgit {
    url = "https://github.com/vysheng/tg.git";
    rev = "6547c0b21b977b327b3c5e8142963f4bc246187a";
    fetchSubmodules = true;
    hash = "sha256-8vOP/4sojvAKVpIRh7k3FR9ZqRilOHTrac8LblnRWh8=";
  };

  buildInputs = with pkgs; [
    libgcrypt
    libevent
    readline
    libconfig
    jansson
    zlib
  ];

  # The upstream code predates modern GCC defaults.
  env.NIX_CFLAGS_COMPILE = "-std=gnu11 -fcommon -Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types";
  postPatch = ''
    substituteInPlace Makefile.in --replace-fail "-Werror " ""
    substituteInPlace loop.c --replace-fail "#include <openssl/sha.h>" "#include <crypto/sha.h>"
  '';
  configureFlags = [
    "--disable-openssl"
    "--disable-liblua"
  ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/telegram-cli $out/bin/telegram-cli
    runHook postInstall
  '';

  meta = {
    description = "Telegram command-line client from vysheng/tg";
    homepage = "https://github.com/vysheng/tg";
    license = pkgs.lib.licenses.gpl2Plus;
    mainProgram = "telegram-cli";
    platforms = pkgs.lib.platforms.linux;
  };
}
