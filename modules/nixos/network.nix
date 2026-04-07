{ pkgs, ... }:

{
  networking.hostName = "laptop";

  networking.networkmanager = {
    enable = true;

    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
}
