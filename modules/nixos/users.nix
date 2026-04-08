{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;

  users.users.nighteugene = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "dialout"
      "docker"
      "input"
      "kvm"
      "networkmanager"
      "plugdev"
      "wheel"
    ];
  };
}
