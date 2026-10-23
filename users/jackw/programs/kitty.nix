# users/jackw/programs/kitty.nix
# kitty on the Macs: Space Mono, slightly translucent, and a muted pastel dark
# palette (softer than Catppuccin, so colored output doesn't glare).
#
# The app comes from the `kitty` cask in hosts/mac/common.nix, so package is
# null here and home-manager only writes the config.
{ ... }:

{
  programs.kitty = {
    enable = true;
    package = null;

    font = {
      # The "Mono" variant: kitty only uses strictly monospaced fonts, and
      # plain "SpaceMono Nerd Font" (double-width icons) falls back to Menlo.
      name = "SpaceMono Nerd Font Mono"; # the font-space-mono-nerd-font cask
      size = 12;
    };

    settings = {
      window_padding_width = 8;
      scrollback_lines = 10000;
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      mouse_hide_wait = -1; # hide the pointer as soon as you type
      confirm_os_window_close = 0;
      macos_titlebar_color = "background";
      macos_quit_when_last_window_closed = true;

      # Slightly see-through, with the desktop blurred behind it.
      background_opacity = "0.82";
      background_blur = 24;

      # Palette
      background = "#1d1f27";
      foreground = "#d4d6de";
      cursor = "#d4d6de";
      cursor_text_color = "#1d1f27";
      selection_background = "#3a3e4d";
      selection_foreground = "#d4d6de";
      url_color = "#8fa8d6";
      active_border_color = "#8fa8d6";
      inactive_border_color = "#2a2d37";

      color0 = "#2a2d37"; # black
      color8 = "#5c6070";
      color1 = "#d88c9a"; # red
      color9 = "#e3a1ad";
      color2 = "#9fc29b"; # green
      color10 = "#b2d1ae";
      color3 = "#d9c393"; # yellow
      color11 = "#e3d0a6";
      color4 = "#8fa8d6"; # blue
      color12 = "#a3b8de";
      color5 = "#b9a0d4"; # magenta
      color13 = "#c7b2de";
      color6 = "#8ec1bf"; # cyan
      color14 = "#a3cfcd";
      color7 = "#b8bbc6"; # white
      color15 = "#d4d6de";
    };
  };
}
