{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Laptop-specific hardware setup (no NVIDIA)
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];
}
