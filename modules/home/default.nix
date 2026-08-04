{
  pkgs,
  inputs,
  config,
  ...
}:

let
  kuna = pkgs.rustPlatform.buildRustPackage {
    pname = "kuna";
    version = "0.1.0";
    src = inputs.kuna;
    sourceRoot = "source/decompiler";

    cargoLock.lockFile = "${inputs.kuna}/decompiler/Cargo.lock";
    cargoBuildFlags = [ "-p kuna-cli" ];

    doCheck = false;

    meta.mainProgram = "kuna";
  };
in
{
  imports = [
    ./shell
    ./term.nix
    ./niri.nix
    ./max.nix
    ./yandex-browser.nix
    inputs.aurora-sdk.homeModules.default
    ./tg-ws-proxy.nix
    ./vim.nix
    ./options.nix
    ./rutracker-proxy.nix
    ./dotfiles.nix
    ./osc.nix
  ];

  programs.aurora-sdk.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk4.theme = config.gtk.theme;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 11;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
      cursor-theme = "Bibata-Modern-Classic";
      monospace-font-name = "JetBrainsMono Nerd Font Mono 11";
      document-font-name = "JetBrainsMono Nerd Font 11";
    };
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.gnome.Evince.desktop";
      };
    };
  };

  home = {
    stateVersion = "25.11";

    # Proton не может создавать symlinks на NTFS (/mnt/games).
    # Перенаправляем compatdata на ext4.
    sessionVariables = {
      STEAM_COMPAT_DATA_PATH = "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
    };

    sessionPath = [
      "${config.home.homeDirectory}/scripts"
    ];

    packages = with pkgs; [
      fastfetch
      brightnessctl
      xwayland-satellite
      just
      nh
      tree
      file
      gimp
      wl-clipboard
      opencode
      clang
      telegram-desktop
      mattermost-desktop
      eog
      wayland-utils
      qbittorrent
      vlc
      bibata-cursors
      python3
      git-repo
      rpm
      expect
      inputs.kimi-code.packages.${pkgs.stdenv.hostPlatform.system}.default
      kuna
    ];
  };
}
