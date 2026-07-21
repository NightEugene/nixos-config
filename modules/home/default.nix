{ pkgs, inputs, config, ... }:
{
  imports = [
    ./shell
    ./term.nix
    ./niri.nix
    ./max.nix
    ./yandex-browser.nix
    ./aurora-sdk.nix
    ./tg-ws-proxy.nix
    ./vim.nix
    ./options.nix
    ./rutracker-proxy.nix
    ./dotfiles.nix
  ];

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
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
      cursor-theme = "Adwaita";
    };
  };

  home = {
    stateVersion = "25.11";

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
      python3
      git-repo
      rpm
      inputs.kimi-code.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
