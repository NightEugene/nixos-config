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

  # Noctalia запускает systemctl hibernate из user service, который Polkit
  # не считает активной локальной сессией. Разрешаем владельцу ПК гибернацию.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.user == "nighteugene" &&
        (action.id == "org.freedesktop.login1.hibernate" ||
          action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  security.rtkit.enable = true;
}
