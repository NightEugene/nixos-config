{ inputs, ... }:

{
  imports = [
    inputs.grub2-themes.nixosModules.default
  ];

  boot.loader.grub2-theme = {
    enable = true;
    theme = "stylish";
    icon = "color";
    screen = "1080p";
  };
}
