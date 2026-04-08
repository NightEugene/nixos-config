{ inputs, pkgs, ... }:

let
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  imports = [
    inputs.niri.homeModules.niri
  ];

  programs.niri = {
    enable = true;

    settings = {
      layout = {
        gaps = 0;

        focus-ring.enable = false;

        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width = {
          proportion = 1.0 / 2.0;
        };

        always-center-single-column = true;
      };

      input = {
        focus-follows-mouse.enable = true;
        workspace-auto-back-and-forth = false;

        keyboard = {
          xkb = {
            layout = "us,ru";
            options = "grp:caps_toggle";
          };
        };
      };

      spawn-at-startup = [
        { argv = [ "noctalia-shell" ]; }
      ];

      hotkey-overlay.skip-at-startup = true;

      binds = {
        "Mod+Return".action.spawn = "alacritty";

        "Mod+H".action.show-hotkey-overlay = [ ];

        "Mod+Q" = {
          action.close-window = [ ];
          repeat = false;
        };
        "Mod+O" = {
          action.toggle-overview = [ ];
          repeat = false;
        };
        "Mod+F".action.maximize-column = [ ];
        "Mod+Shift+F".action.fullscreen-window = [ ];

        "Mod+Space".action.switch-focus-between-floating-and-tiling = [ ];
        "Mod+Shift+Space".action.toggle-window-floating = [ ];

        "Mod+R".action.switch-preset-column-width = [ ];
        "Mod+C".action.center-column = [ ];
        "Mod+V".action.toggle-column-tabbed-display = [ ];
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+Up".action.focus-window-up = [ ];
        "Mod+Down".action.focus-window-down = [ ];

        "Mod+Shift+Left".action.move-column-left = [ ];
        "Mod+Shift+Right".action.move-column-right = [ ];
        "Mod+Shift+Up".action.move-window-up = [ ];
        "Mod+Shift+Down".action.move-window-down = [ ];

        "Mod+D".action.spawn = noctalia "launcher toggle";
        "Mod+P".action.spawn = noctalia "sessionMenu toggle";

        "Mod+Print".action.screenshot = [ ];
        "Print".action.screenshot-screen = [ ];
        "Alt+Print".action.screenshot-window = [ ];

        "Mod+Tab".action.focus-window-down-or-column-right = [ ];
        "Mod+Shift+Tab".action.focus-window-up-or-column-left = [ ];
        "Mod+Comma".action.consume-window-into-column = [ ];
        "Mod+Period".action.expel-window-from-column = [ ];

        "Mod+Shift+E".action.quit = [ ];
        "Mod+Shift+P".action.power-off-monitors = [ ];

        "XF86AudioRaiseVolume".action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
        "XF86AudioLowerVolume".action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
        "XF86AudioMute".action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        "XF86MonBrightnessUp".action.spawn-sh = "brightnessctl set 10%+";
        "XF86MonBrightnessDown".action.spawn-sh = "brightnessctl set 10%-";

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+0".action.focus-workspace = 0;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;
        "Mod+Shift+0".action.move-column-to-workspace = 0;

        "Mod+Shift+Ctrl+T".action.toggle-debug-tint = [ ];
      };
    };
  };
}
