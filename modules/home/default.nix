{
  pkgs,
  inputs,
  config,
  ...
}:

let
  # xwayland-satellite 0.8.3 с тёмными декорациями X11-окон (патч decoration.rs:
  # белый тайтл-бар #353535, как на рабочей Ubuntu-машине)
  satelliteSrc = pkgs.fetchFromGitHub {
    owner = "Supreeeme";
    repo = "xwayland-satellite";
    rev = "v0.8.3";
    hash = "sha256-eFEjCCniMCKeWU0PcZNv+tDYe08SLFPjRplyPY8OFt4=";
  };

  xwayland-satellite = pkgs.xwayland-satellite.overrideAttrs (old: {
    version = "0.8.3";
    src = satelliteSrc;
    cargoHash = "sha256-gMGFvnbxM3hD5fmkSimaFd87GEf6BXFe/MGjoS6VNVU=";
    # overrideAttrs не пересчитывает cargoDeps — задаём вендор явно
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      pname = "xwayland-satellite";
      version = "0.8.3";
      src = satelliteSrc;
      hash = "sha256-gMGFvnbxM3hD5fmkSimaFd87GEf6BXFe/MGjoS6VNVU=";
    };
    postPatch = (old.postPatch or "") + ''
      cp ${./xwayland-satellite-decoration.rs} src/server/decoration.rs
    '';
  });

  kuna = pkgs.rustPlatform.buildRustPackage {
    pname = "kuna";
    version = "0.1.0";
    src = inputs.kuna;
    sourceRoot = "source/decompiler";

    cargoLock.lockFile = "${inputs.kuna}/decompiler/Cargo.lock";
    cargoBuildFlags = [
      "-p kuna-cli"
      "-p kuna-console"
      "-p kuna-harness"
      "-p kuna-slacomp"
    ];

    nativeBuildInputs = [ pkgs.makeWrapper ];

    doCheck = false;

    postBuild = ''
      target=$(rustc -vV | sed -n 's|host: ||p')
      cp -r ../specs specs-build
      chmod -R +w specs-build
      ./target/"$target"/release/slacomp -a specs-build
    '';

    installPhase = ''
      runHook preInstall

      target=$(rustc -vV | sed -n 's|host: ||p')
      local releaseDir="target/$target/release"

      mkdir -p $out/bin $out/share/kuna/specs
      cp "$releaseDir"/kuna $out/bin/
      cp "$releaseDir"/decomp_dbg $out/bin/
      cp "$releaseDir"/decomp_test_dbg $out/bin/
      cp "$releaseDir"/slacomp $out/bin/
      cp -r specs-build/. $out/share/kuna/specs/

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/kuna --set KUNA_SPECS "$out/share/kuna/specs"
    '';

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
    ./vscode.nix
    ./options.nix
    ./rutracker-proxy.nix
    ./dotfiles.nix
    ./osc.nix
    ./spflashtool.nix
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

  # Qt4-приложения (SP Flash Tool 5) не читают QT_* env — стиль задаём
  # через глобальный конфиг Qt4: GTK+ style рендерится темой GTK2 (Adwaita-dark)
  home.file.".config/Trolltech.conf".text = ''
    [Qt]
    style=GTK+
  '';

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
      steamguard-cli
      (import ./gotd-cli.nix { inherit pkgs; })
      mattermost-desktop
      eog
      wayland-utils
      qbittorrent
      vlc
      bibata-cursors
      (python3.withPackages (ps: [ ps.pillow ps.pyyaml ]))
      git-repo
      rpm
      expect
      gh
      pngquant
      gpu-screen-recorder
      # libgtk-x11-2.0 для QGtkStyle (Qt4, SP Flash Tool 5) — резолвится через dlopen
      gtk2
      inputs.kimi-code.packages.${pkgs.stdenv.hostPlatform.system}.default
      kuna
      ghidra
      md-tui
      inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
      jmtpfs
      android-tools
      unzip
      pmbootstrap
      (import ./codex.nix { inherit pkgs; })
      (import ./pi.nix { inherit pkgs; })
      (import ./yt-dlp.nix { inherit pkgs; })
      ffmpeg
      imagemagick
      deno # JS-runtime для yt-dlp (PO token provider)
      mpv
    ];
  };
}
