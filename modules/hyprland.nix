{ config, pkgs, inputs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true; # or disable if you prefer greetd
  services.desktopManager.plasma6.enable = false;

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Optionally use Wayland login manager (like `greetd`)
  # services.greetd = {
  #   enable = true;
  #   defaultSession = "Hyprland";
  # };

  # Hyprland-specific packages
  environment.systemPackages = with pkgs; [
    hyprland
    waybar
    rofi
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
