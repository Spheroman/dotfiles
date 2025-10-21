{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true; # or disable if you prefer greetd
  services.xserver.desktopManager.plasma5.enable = false; # Disable KDE
  services.xserver.desktopManager.plasma6.enable = false;
  services.xserver.windowManager.hyprland.enable = true;

  # Optionally use Wayland login manager (like `greetd`)
  # services.greetd = {
  #   enable = true;
  #   defaultSession = "Hyprland";
  # };

  # Hyprland-specific packages
  environment.systemPackages = with pkgs; [
    hyprland
    waybar
    rofi-wayland
    kitty
    mako
    hyprpaper
  ];

  # Set environment variables recommended for Wayland
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
}
