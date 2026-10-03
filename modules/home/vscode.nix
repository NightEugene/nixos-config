{ pkgs, ... }:

let
  flora = pkgs.vscode-utils.buildVscodeExtension {
    pname = "omp-flora";
    version = "0.2.0";
    vscodeExtPublisher = "OMP";
    vscodeExtName = "flora";
    vscodeExtUniqueId = "OMP.flora";

    src = pkgs.fetchurl {
      url = "https://sdk-repo.omprussia.ru/sdk/flutter/vscode_extensions/flora/flora-0.2.0.vsix";
      hash = "sha256-JcxSjQ++yw0GvIze03YGl6r6zEDdfGVWxftuRbAW3uk=";
    };
  };
in
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      dart-code.dart-code
      dart-code.flutter
      flora
    ];
  };
}
