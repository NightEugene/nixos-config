{
  description = "NightEugene's NixOS config";

  nixConfig = {
    substituters = [
      "https://mirror.yandex.ru/nixos"
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    grub2-themes.url = "github:vinceliuice/grub2-themes";
    grub2-themes.inputs.nixpkgs.follows = "nixpkgs";

    nix4nvchad.url = "github:nix-community/nix4nvchad";
    nix4nvchad.inputs.nixpkgs.follows = "nixpkgs";

    happ-nixos.url = "github:MrShitFox/happ-nixos";
    happ-nixos.flake = false;

    kimi-code.url = "github:MoonshotAI/kimi-code";

    aurora-sdk.url = "github:NightEugene/aurora-sdk-nix";
    aurora-sdk.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    kuna.url = "github:Noelo-Lab/kuna";
    kuna.flake = false;

    hermes-agent.url = "github:NousResearch/hermes-agent";

    # Внутренние пакеты SP Flash Tool; ревизии зафиксированы для воспроизводимости.
    tz-auto.url = "git+ssh://git@os-git.omprussia.ru/trustzone/automation/flake.git?rev=6edc5df08e1d99fee7d308dd6761c8be3ba97626";

    spflashtool5-src = {
      url = "git+ssh://git@os-git.omprussia.ru/trustzone/automation/flash-utils.git?rev=99cbba660ebf57ecbc6c39bbb8df4dd0626c0780";
      flake = false;
    };
    spflashtool6-src = {
      url = "git+ssh://git@os-git.omprussia.ru/trustzone/automation/flash-utils.git?rev=6b691be4f2a43b7313feb38d19182740c620ed31";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt;

          packages = {
            qcow = inputs.nixos-generators.nixosGenerate {
              system = "x86_64-linux";
              format = "qcow";
              specialArgs = {
                inherit inputs;
                flake = self;
              };
              modules = [
                inputs.disko.nixosModules.disko
                inputs.home-manager.nixosModules.home-manager
                self.nixosModules.default
                {
                  networking.hostName = "qemu";

                  home-manager = {
                    extraSpecialArgs = {
                      inherit inputs;
                      flake = self;
                    };
                    users.nighteugene = import ./hosts/qemu/users/nighteugene/home-configuration.nix;
                  };
                }
                ./hosts/qemu/configuration.nix
              ];
            };
          };

          checks = {
            pc = self.nixosConfigurations.pc.config.system.build.toplevel;
            laptop = self.nixosConfigurations.laptop.config.system.build.toplevel;
            qemu = self.nixosConfigurations.qemu.config.system.build.toplevel;
          };
        };

      flake = {
        nixosModules.default = import ./modules/nixos/default.nix;

        homeModules = {
          default = import ./modules/home/default.nix;
          noctaliaPC = import ./modules/home/noctaliaPC.nix;
          noctaliaLaptop = import ./modules/home/noctaliaLaptop.nix;
        };

        nixosConfigurations =
          let
            mkHost =
              hostname: extraModules:
              inputs.nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                  inherit inputs;
                  flake = self;
                };
                modules = [
                  inputs.disko.nixosModules.disko
                  inputs.home-manager.nixosModules.home-manager
                  self.nixosModules.default
                  {
                    networking.hostName = hostname;

                    home-manager = {
                      extraSpecialArgs = {
                        inherit inputs;
                        flake = self;
                      };
                      users.nighteugene = import ./hosts/${hostname}/users/nighteugene/home-configuration.nix;
                    };
                  }
                ]
                ++ extraModules;
              };
          in
          {
            pc = mkHost "pc" [ ./hosts/pc/configuration.nix ];
            laptop = mkHost "laptop" [ ./hosts/laptop/configuration.nix ];
            qemu = mkHost "qemu" [ ./hosts/qemu/configuration.nix ];
          };

      };
    };
}
