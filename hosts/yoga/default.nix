# hosts/yoga/default.nix
# Lenovo Yoga 7 2-in-1 14AKP10 (Ryzen AI 5 340 / Radeon 840M, 14" 1920x1200).
# Started from hosts/generic; this file is that plus what a laptop needs.
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/cosmic.nix
  ];

  # Must match the flake attr so `rebuild` (nh) picks this config.
  networking.hostName = "yoga";

  # amdgpu and the RTL8922AE WiFi both need firmware blobs; also lets
  # hardware-configuration.nix's microcode default take effect.
  hardware.enableRedistributableFirmware = true;

  services.logind.settings.Login.HandlePowerKey = "suspend";

  # Power profiles (balanced / power-saver / performance) on top of amd-pstate.
  services.power-profiles-daemon.enable = true;

  # Battery charge limit: "Long_Life" is the kernel's name for Lenovo's
  # conservation mode. Write "Standard" to the same file to charge to 100%
  # until the next boot.
  systemd.tmpfiles.rules = [
    "w /sys/class/power_supply/BAT0/charge_types - - - - Long_Life"
  ];

  environment.systemPackages = with pkgs; [
    source-code-pro
  ];

  # Podman for containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # zRAM on top of the swap partition in hardware-configuration.nix.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
