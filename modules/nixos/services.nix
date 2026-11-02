{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    (import "${inputs.happ-nixos}/happ-module.nix")
  ];

  services = {
    libinput.enable = true;
    upower.enable = true;
    # power-profiles-daemon conflicts with services.auto-cpufreq (enabled in hardware-configuration.nix)
    thermald.enable = true;
    fstrim.enable = true;

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${config.programs.niri.package}/bin/niri-session";
          user = "greeter";
        };
      };
    };

    happ.enable = true;
  };

  security.rtkit.enable = true;
}
