{ pkgs, lib, ... }:

{
  networking.hostName = lib.mkDefault "laptop";

  networking.networkmanager = {
    enable = true;

    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  # happ/sing-box создаёт TUN-интерфейс, но пакеты могут отбрасываться
  # из-за reverse path filtering, так как входящий и исходящий маршруты
  # асимметричны (в tun0, обратно — через WiFi).
  boot.kernel.sysctl = {
    "net.ipv4.conf.tun0.rp_filter" = 0;
    "net.ipv4.conf.all.rp_filter" = 0;
  };

  # Импорт рабочего OpenVPN-профиля в NetworkManager.
  # Сам .ovpn содержит приватный ключ, поэтому в репозиторий и nix store
  # его класть нельзя — импортируем из локального файла, если он есть.
  # Идемпотентно: если подключение уже существует (в т.ч. добавленное
  # вручную через GUI), ничего не делаем.
  systemd.services.nm-import-omp-vpn =
    let
      vpnName = "OMP_e.todoruk";
      ovpnFile = "/home/nighteugene/work/vpn/OMP_e.todoruk.ovpn";
    in
    {
      description = "Import ${vpnName} OpenVPN profile into NetworkManager";
      wantedBy = [ "multi-user.target" ];
      after = [ "NetworkManager.service" ];
      wants = [ "NetworkManager.service" ];

      path = [ pkgs.networkmanager ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        # ждём, пока NetworkManager станет доступен по D-Bus
        for i in $(seq 1 30); do
          nmcli -t general status >/dev/null 2>&1 && break
          sleep 1
        done

        if nmcli -t -f NAME connection show | grep -Fxq '${vpnName}'; then
          exit 0
        fi

        if [ ! -f '${ovpnFile}' ]; then
          echo "${ovpnFile} not found, skipping import"
          exit 0
        fi

        nmcli connection import type openvpn file '${ovpnFile}'
      '';
    };
}
