{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.tg-ws-proxy;

  tg-ws-proxy-rs = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "tg-ws-proxy-rs";
    version = "1.6.4";

    src = pkgs.fetchurl {
      url = "https://github.com/valnesfjord/tg-ws-proxy-rs/releases/download/v${version}/tg-ws-proxy-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-izSwUj6Go5vpPG3ACxGGFHQeXstzXxwwoUXWceUAS40=";
    };

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/bin
      install -Dm755 tg-ws-proxy $out/bin/tg-ws-proxy
    '';

    meta = {
      description = "Telegram MTProto WebSocket Bridge Proxy (Rust port)";
      homepage = "https://github.com/valnesfjord/tg-ws-proxy-rs";
      license = pkgs.lib.licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  options.programs.tg-ws-proxy = {
    enable = lib.mkEnableOption "tg-ws-proxy — Telegram MTProto WebSocket bridge proxy";

    package = lib.mkOption {
      type = lib.types.package;
      default = tg-ws-proxy-rs;
      description = "The tg-ws-proxy package to use.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = lib.literalExpression ''
        [
          "--default-domains"
          "--cf-priority"
        ]
      '';
      description = ''
        Extra command-line arguments passed to tg-ws-proxy.
        See the upstream README for available flags.
      '';
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        {
          TG_DEFAULT_DOMAINS = "true";
          TG_CF_DOMAIN = "yourdomain.com";
        }
      '';
      description = ''
        Additional environment variables for the tg-ws-proxy service.
        tg-ws-proxy also reads standard HTTPS_PROXY/ALL_PROXY/NO_PROXY variables.
      '';
    };
  };

  config = lib.mkMerge [
    {
      programs.tg-ws-proxy = {
        enable = lib.mkDefault true;
        extraArgs = [
          "--default-domains"
          "--cf-priority"
        ];
      };
    }

    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];

      systemd.user.services.tg-ws-proxy = {
        Unit = {
          Description = "Telegram MTProto WebSocket Bridge Proxy";
          After = [ "network.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = lib.escapeShellArgs ([ "${cfg.package}/bin/tg-ws-proxy" ] ++ cfg.extraArgs);
          Restart = "on-failure";
          RestartSec = "5";
          Environment = lib.optionals (cfg.extraEnvironment != { }) (
            lib.mapAttrsToList (name: value: "${name}=${value}") cfg.extraEnvironment
          );
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    })
  ];
}
