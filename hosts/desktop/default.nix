# hosts/desktop/default.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/cosmic.nix
    # Alternative: use KDE instead
    # ../../modules/desktop/kde.nix
  ];

  networking.hostName = "nixos";

  services.logind.settings.Login.HandlePowerKey = "suspend";


  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    source-code-pro
  ];

  # Podman for containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  # Swap file
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  } ];

  # zRAM Swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
