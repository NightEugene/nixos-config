{ pkgs, ... }:

{
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.pmount.enable = true;
  programs.vim.enable = true;
  programs.nm-applet.enable = true;
  programs.evince.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.steam.enable = true;

  # gpu-screen-recorder: серверу захвата KMS нужен cap_sys_admin,
  # чтобы не запрашивать root через pkexec при каждой записи
  security.wrappers.gsr-kms-server = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+ep";
    source = "${pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
  };
}
