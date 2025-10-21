{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    extraConfig = ''
      # Example Hyprland config
      monitor=,preferred,auto,1
      exec-once = waybar &
      exec-once = mako &
      exec-once = hyprpaper &
      bind = SUPER, Return, exec, alacritty
      bind = SUPER, Q, killactive,
      bind = SUPER, M, exit,
      bind = SUPER, SPACE, exec, rofi -show drun
    '';
  };

  programs.waybar.enable = true;
  programs.rofi.enable = true;

  # Example notifications and wallpaper utilities
  services.mako.enable = true;
  services.hyprpaper.enable = true;

  home.packages = with pkgs; [
    kitty
    rofi
  ];
}
