{ config, ... }:

{
  services.libinput.enable = true;
  services.openssh.enable = true;
  services.upower.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "nighteugene";
      };
    };
  };
}
