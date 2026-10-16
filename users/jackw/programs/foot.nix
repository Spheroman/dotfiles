# users/jackw/foot.nix
# Foot terminal with daemon mode for fast startup
{ config, pkgs, lib, ... }:

{
  programs.foot = {
    enable = true;
    server.enable = true;  # Enable daemon mode

    settings = {
      main = {
        term = "xterm-256color";
        font = "SpaceMono Nerd Font:size=10";
        dpi-aware = "no";  # size follows monitor scale, not physical DPI (yes made it too big)
        pad = "8x8";
      };

      scrollback = {
        lines = 10000;
      };

      mouse = {
        hide-when-typing = "yes";
      };

      cursor = {
        style = "beam";
        blink = "yes";
      };

      # foot 1.28 renamed [colors] to [colors-dark] (and added [colors-light]).
      # Opaque, with the shell's Material surfaces for seed hue 160: the
      # background is surfaceContainerLow, like the shell's windows.
      colors-dark = {
        background = "0f1713";  # surfaceContainerLow
        foreground = "dee7e2";  # fgSurface
        selection-background = "005031";  # primaryContainer
        selection-foreground = "dee7e2";

        # Normal colors
        regular0 = "242e28";  # black (surfaceContainerHighest)
        regular1 = "e06c75";  # red
        regular2 = "98c379";  # green
        regular3 = "e5c07b";  # yellow
        regular4 = "61afef";  # blue
        regular5 = "c678dd";  # magenta
        regular6 = "56b6c2";  # cyan
        regular7 = "abb2bf";  # white

        # Bright colors
        bright0 = "76847c";   # bright black (outline)
        bright1 = "e06c75";   # bright red
        bright2 = "98c379";   # bright green
        bright3 = "e5c07b";   # bright yellow
        bright4 = "61afef";   # bright blue
        bright5 = "c678dd";   # bright magenta
        bright6 = "56b6c2";   # bright cyan
        bright7 = "ffffff";   # bright white
      };

      key-bindings = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
        scrollback-up-page = "Shift+Page_Up";
        scrollback-down-page = "Shift+Page_Down";
        search-start = "Control+Shift+f";
      };
    };
  };
}
