# users/wenyu/foot.nix
# Foot terminal with daemon mode for fast startup
{ config, pkgs, lib, ... }:

{
  programs.foot = {
    enable = true;
    server.enable = true;  # Enable daemon mode

    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:size=10";
        dpi-aware = "yes";
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

      colors = {
        alpha = "0.92";
        background = "1a1a1a";
        foreground = "e0e0e0";

        # Normal colors
        regular0 = "1a1a1a";  # black
        regular1 = "e06c75";  # red
        regular2 = "98c379";  # green
        regular3 = "e5c07b";  # yellow
        regular4 = "61afef";  # blue
        regular5 = "c678dd";  # magenta
        regular6 = "56b6c2";  # cyan
        regular7 = "abb2bf";  # white

        # Bright colors
        bright0 = "5c6370";   # bright black
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
