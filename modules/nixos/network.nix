{ pkgs, lib, ... }:

{
  networking.hostName = lib.mkDefault "laptop";

  networking.networkmanager = {
    enable = true;

    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };
}
