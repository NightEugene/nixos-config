{ config, lib, ... }:

let
  zshCustomTheme = {
    name = "nighteugene-theme";
    src = lib.cleanSource ./zsh;
    file = "nighteugene.zsh-theme";
  };

  zshJustfilePlugin = {
    name = "zsh-justfile";
    src = lib.cleanSource ./zsh;
    file = "zsh-justfile.plugin.zsh";
  };
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };

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
      zshJustfilePlugin
    ];

    initContent = ''
      # Launch kimi in the NixOS config directory and load SESSION.md context
      nixos-kimi() {
        local config_dir="/home/nighteugene/git/nighteugene/nixos-config"
        if [ ! -d "$config_dir" ]; then
          echo "nixos-kimi: directory $config_dir not found" >&2
          return 1
        fi
        cd "$config_dir" || return 1
        exec kimi "$@"
      }
    '';
  };
}
