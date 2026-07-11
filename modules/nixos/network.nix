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
}
