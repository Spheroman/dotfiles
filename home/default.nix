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
      steam
      libreoffice-fresh
      hunspell
      hunspellDicts.en-us
      nwg-look
      
      (appimageTools.wrapType2 {
        pname = "browseros";
        version = "0.28.1";
        src = fetchurl {
          url = "https://github.com/browseros-ai/BrowserOS/releases/download/v0.28.1/BrowserOS_v0.28.1_x64.AppImage";
          sha256 = "sha256-YY3g0xNr/Jm4Q1PJSg27vO+M5jur/lM2a6iTN03BbCA=";
        };
      })
    ];
  };

  programs.home-manager.enable = true;
}
