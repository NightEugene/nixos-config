{ config, lib, ... }:

let
  zshCustomTheme = {
    name = "nighteugene-theme";
    src = lib.cleanSource ./zsh;
    file = "nighteugene.zsh-theme";
  };
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

    syntaxHighlighting = {
      enable = true;
      styles = {
        autodirectory = "fg=green";
        suffix-alias = "fg=green";
        path = "fg=cyan";
        precommand = "fg=green";
      };
    };

    history = {
      size = 10000;
      ignoreAllDups = true;
      share = false;
      path = "$HOME/.zsh_history";
    };

    oh-my-zsh = {
      enable = true;
    };

    plugins = [
      zshCustomTheme
    ];

    initContent = ''
      source ${zshCustomTheme.src}/${zshCustomTheme.file}
    '';
  };
}
