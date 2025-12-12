# modules/desktop/cosmic.nix
{ config, pkgs, ... }:

{
  services.desktopManager.cosmic.enable = true;
  
  environment.systemPackages = with pkgs; [
    # Add any extra COSMIC related packages here if needed
  ];

  environment.cosmic.excludePackages = [
    pkgs.cosmic-store
    pkgs.cosmic-term
    pkgs.networkmanagerapplet
  ];

  services.system76-scheduler.enable = true;
}
