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
        path = "none";
        precommand = "fg=green";
      };
    };

    history = {
      size = 10000;
      ignoreAllDups = true;
      path = "$HOME/.zsh_history";
    };
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "jispwoso";
  };
}
