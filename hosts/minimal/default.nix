# hosts/minimal/default.nix
# Minimal TTY-only configuration for emergency recovery
{ config, pkgs, ... }:

{
  imports = [
    ../../modules/core
  ];

  networking.hostName = "nixos-minimal";

  # No graphical environment - pure TTY recovery mode
  # This is intentionally minimal for debugging

  # Enable SSH for remote recovery
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Basic recovery packages
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    tmux
    curl
    wget
    parted
    gptfdisk
    e2fsprogs
    btrfs-progs
  ];

  # Serial console for debugging
  boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" ];

  # Simple boot loader menu
  boot.loader.timeout = 5;

  system.stateVersion = "25.11";
}
