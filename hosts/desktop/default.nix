# hosts/desktop/default.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/greetd.nix
    # Alternative: use KDE instead
    # ../../modules/desktop/kde.nix
  ];

  networking.hostName = "nixos";

  services.logind.powerKey = "suspend";


  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    source-code-pro
  ];
}
