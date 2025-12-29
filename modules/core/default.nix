# modules/core/default.nix
# Core system configuration shared across all hosts
{ config, pkgs, ... }:

{
  # Localization
  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Networking
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  networking.wireless.iwd = {
    enable = true;
    settings = {
      Network.EnableIPv6 = true;
      Settings.AutoConnect = true;
    };
  };

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

  # Enable direnv system-wide
  programs.direnv.enable = true;

  # Maintenance
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ "root" "@wheel" ];
    substituters = [
      "https://cache.nixos.org"
      "https://cache.soopy.moe"
      "https://cosmic.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjXG1hB8uQlD4Jm159stq68OOp71s="
    ];
  };

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Services
  services.printing.enable = true;
  services.openssh.enable = true;
  services.solaar.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
  };

  users.groups.admin = {};
  # User configuration
  users.users.jackw = {
    isNormalUser = true;
    description = "Jack Wen";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "tty" "dialout" "admin" "podman"];
    initialPassword = "jackw";  # Only sets password on first user creation
  };

  users.users.wenyu = {
    isNormalUser = true;
    description = "Wang Wenyu";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "tty" "dialout" "admin"];
    initialPassword = "wenyu";  # Only sets password on first user creation
  };

  systemd.tmpfiles.rules = [
    "d /home/jackw/nixos-config o775 jackw admin - -"
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    distrobox
  ];

  programs.nix-ld.enable = true;

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    miracode
  ];

  # Shell Aliases
  environment.shellAliases = {
    ll = "ls -l";
    gc = "nix-collect-garbage -d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Programs
  programs.firefox.enable = true;

  # Graphics
  hardware.graphics.enable = true;

  # Wayland environment variables
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "25.11";

  programs.steam.enable = true;
}
