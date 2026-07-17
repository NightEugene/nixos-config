{ lib, ... }:

{
  options.my = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "nighteugene";
      description = "Primary username for home-manager configuration.";
    };

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Pointer cursor size in pixels.";
    };
  };
}
