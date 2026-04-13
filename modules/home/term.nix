{ ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      font.normal = {
        family = "JetBrainsMono Nerd Font Mono";
        style = "Regular";
      };
      font.bold = {
        family = "JetBrainsMono Nerd Font Mono";
        style = "Bold";
      };
      font.bold_italic = {
        family = "JetBrainsMono Nerd Font Mono";
        style = "Bold Italic";
      };
      font.italic = {
        family = "JetBrainsMono Nerd Font Mono";
        style = "Italic";
      };
    };
  };
}
