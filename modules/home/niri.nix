{ inputs, ... }:

{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri = {
    enable = true;

    settings = {
      spawn-at-startup = [
        { argv = [ "noctalia-shell" ]; }
      ];
    };
  };
}
