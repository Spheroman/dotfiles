# hosts/generic/default.nix
# Hardware-agnostic desktop: same desktop environment, services, and apps as
# hosts/desktop, minus the NVIDIA module and anything tied to that machine's
# disks or CPU. Use it as the starting point for a fresh install.
#
# The one machine-specific piece is hardware-configuration.nix, which must be
# generated on the target with `nixos-generate-config` and `git add`ed — see
# "Installing on a new NixOS machine" in README.md. It's imported only if
# present so the host still evaluates (and fails with NixOS's own clear
# "fileSystems" assertion) before that step is done.
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/cosmic.nix
  ] ++ builtins.filter builtins.pathExists [ ./hardware-configuration.nix ];

  # Must match the flake attr so `rebuild` (nh) picks this config.
  networking.hostName = lib.mkDefault "generic";

  # Firmware blobs for whatever WiFi/GPU/CPU the machine turns out to have;
  # also lets hardware-configuration.nix's microcode default take effect.
  hardware.enableRedistributableFirmware = true;

  services.logind.settings.Login.HandlePowerKey = "suspend";

  environment.systemPackages = with pkgs; [
    source-code-pro
  ];

  # Podman for containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # zRAM Swap (no swap file: its size depends on the disk; add one in
  # hardware-configuration.nix or here if the machine needs it)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
