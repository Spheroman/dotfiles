# modules/desktop/kde.nix
{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # KDE-specific packages
  environment.systemPackages = with pkgs; [
    kdePackages.kate
  ];
}
