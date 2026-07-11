{ inputs, ... }:

{
  imports = [
    inputs.grub2-themes.nixosModules.default
  ];

  boot.loader.grub2-theme = {
    enable = true;
    theme = "stylish";
    icon = "white";
    screen = "1080p";
  };
}
