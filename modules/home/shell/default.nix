{ config, ... }:

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
      theme = "nighteugene";
      custom = "$HOME/git/nighteugene/zsh-config";
    };
  };
}
