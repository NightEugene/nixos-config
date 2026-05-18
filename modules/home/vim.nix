{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix4nvchad.homeManagerModules.default
  ];

  programs.nvchad = {
    enable = true;

    backup = false;

    chadrcConfig = ''
      local M = {}
      M.ui = {
        theme = "jabuti",
        transparency = true,
      }
      return M
    '';
  };
}
