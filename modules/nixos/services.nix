{ inputs, config, ... }:

{
  imports = [
    (import "${inputs.happ-nixos}/happ-module.nix")
  ];

  services.libinput.enable = true;
  services.upower.enable = true;
  # power-profiles-daemon conflicts with services.auto-cpufreq (enabled in hardware-configuration.nix)
  services.thermald.enable = true;
  services.fstrim.enable = true;

  security.rtkit.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "nighteugene";
      };
    };
  };

  services.happ.enable = true;
}
