# modules/desktop/hyprland.nix
{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.hayashi.nixosModules.hayashi-shell ];

  # PAM services for the lock screens: the shell's own, and hyprlock, which
  # stays as the fallback when the shell isn't running.
  programs.hayashi-shell.enable = true;
  security.pam.services.hyprlock = { };

  # Desktop services the Hyprland session relies on. These used to arrive
  # with the COSMIC module; hosts without it need them set here.
  services.upower.enable = true;            # battery and power info for the shell
  services.gnome.gnome-keyring.enable = true; # app secrets, e.g. gh's login
  services.gvfs.enable = true;              # trash, mounts and network places in Nemo
  services.udisks2.enable = true;           # removable drives

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # XDG Portal configuration
  xdg.portal = {
    enable = true;
    extraPortals = [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";  # Use first available portal
  };

  # Essential Wayland/Hyprland packages
  environment.systemPackages = with pkgs; [
    ashell
    rofi
    foot
    mako
    hyprpaper
    wl-clipboard
    grim
    slurp
    grimblast  # Screenshot utility
    brightnessctl  # brightness keys and hypridle dimming
    playerctl  # media keys
    swaylock
    swayidle
  ];

  # Wayland environment variables
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  # Enable X11 support for legacy apps
  services.xserver.enable = true;
}
