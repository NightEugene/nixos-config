{ pkgs, ... }:

{
  programs = {
    git.enable = true;
    htop.enable = true;
    pmount.enable = true;
    vim.enable = true;
    nm-applet.enable = true;
    evince.enable = true;
    zsh.enable = true;
    nix-ld.enable = true;
    steam.enable = true;
  };

  # gpu-screen-recorder: серверу захвата KMS нужен cap_sys_admin,
  # чтобы не запрашивать root через pkexec при каждой записи
  security.wrappers.gsr-kms-server = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+ep";
    source = "${pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
  };
}
