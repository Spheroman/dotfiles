# home/default.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.beta
    ./programs
    ./shell.nix
    ./hyprland.nix
  ];

  home = {
    username = "jackw";
    homeDirectory = "/home/jackw";
    stateVersion = "25.05";

    packages = with pkgs; [
      # CLI tools
      neofetch
      nnn
      zip
      xz
      unzip
      p7zip
      ripgrep
      jq
      yq-go
      eza
      fzf
      gh

      # Networking tools
      mtr
      iperf3
      dnsutils
      ldns
      aria2
      socat
      nmap
      ipcalc

      # System monitoring
      btop
      iotop
      iftop
      strace
      ltrace
      lsof
      sysstat
      lm_sensors
      ethtool
      pciutils
      usbutils

      # Development
      jetbrains.pycharm-professional
      vscode
      sqlite
      basedpyright
      python313
      python313Packages.importmagic
      python313Packages.flake8
      lmstudio

      # Misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      gnupg
      dmidecode
      nix-output-monitor
      hugo
      glow

      # Applications
      discord
      teams-for-linux
      noson
      distrobox
      rpi-imager
      inputs.browseros.packages.x86_64-linux.browseros
    ];
  };

  programs.home-manager.enable = true;
}
