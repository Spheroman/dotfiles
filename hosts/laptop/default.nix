# hosts/laptop/default.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/greetd.nix
    # Alternative: use KDE instead
    # ../../modules/desktop/kde.nix
  ];

  networking.hostName = "nix_laptop";

  # T2 MacBook specific configuration
  boot.kernelParams = [
    "mem_sleep_default=s2idle"
    "no_console_suspend"
  ];

  # Suspend fix for T2 MacBook
  systemd.services.suspend-fix-t2 = {
    enable = true;
    description = "Workaround for suspend on t2 macbook";
    before = [ "sleep.target" ];
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      RemainAfterExit = true;
      ExecStart = [
        "/run/current-system/sw/bin/sh -c \"echo 0 > /sys/power/pm_async\""
        "/run/current-system/sw/bin/modprobe -r brcmfmac_wcc"
        "/run/current-system/sw/bin/modprobe -r brcmfmac"
      ];
      ExecStop = [
        "/run/current-system/sw/bin/modprobe brcmfmac"
        "/run/current-system/sw/bin/modprobe brcmfmac_wcc"
      ];
    };
    wantedBy = [ "sleep.target" ];
  };

  # Intel GPU
  services.xserver.videoDrivers = [ "modesetting" ];

  # Power profile management
  services.power-profiles-daemon.enable = true;

  # Podman for containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
