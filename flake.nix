{
  description = "NightEugene's NixOS config";

  nixConfig = {
    substituters = [
      "https://mirror.yandex.ru/nixos"
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

    noctalia.url = "github:noctalia-dev/noctalia-shell/13964255121d100a7306e76a28010f19e8b33a1a";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    grub2-themes.url = "github:vinceliuice/grub2-themes";
    grub2-themes.inputs.nixpkgs.follows = "nixpkgs";

    nix4nvchad.url = "github:nix-community/nix4nvchad";
    nix4nvchad.inputs.nixpkgs.follows = "nixpkgs";

    happ-nixos.url = "github:MrShitFox/happ-nixos";
    happ-nixos.flake = false;

    kimi-code.url = "github:MoonshotAI/kimi-code";
  };

  outputs =
    inputs@{ flake-parts, self, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;
        };

      flake = {
        nixosModules.default = import ./modules/nixos/default.nix;

        homeModules = {
          default = import ./modules/home/default.nix;
          noctaliaPC = import ./modules/home/noctaliaPC.nix;
          noctaliaLaptop = import ./modules/home/noctaliaLaptop.nix;
        };

        nixosConfigurations.pc = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            flake = self;
          };
          modules = [
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            self.nixosModules.default
            ./hosts/pc/configuration.nix
          ];
        };

        nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            flake = self;
          };
          modules = [
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            self.nixosModules.default
            ./hosts/laptop/configuration.nix
          ];
        };
      };
    };
}
