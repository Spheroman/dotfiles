{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];


  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    systemd-boot.enable = true;
  };

  # Laptop-specific hardware setup (no NVIDIA)
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];
}
