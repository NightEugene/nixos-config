{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./network.nix
    ./time.nix
    ./programs.nix
    ./packages.nix
    ./services.nix
    ./users.nix
    ./virt.nix
    ./grub.nix
    ./swap.nix
  ];

  system.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  boot.tmp.useTmpfs = true;

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.common.default = "*";
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.dconf.enable = true;
}
