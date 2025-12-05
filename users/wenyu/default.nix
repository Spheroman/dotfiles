{ pkgs, inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.beta
    ./programs
    ./shell.nix
    ./hyprland.nix
  ];

  home.username = "wenyu";
  home.homeDirectory = "/home/wenyu";

  home.stateVersion = "24.11";

  # Default packages similar to Ubuntu installation
  home.packages = with pkgs; [
    # Core utilities
    coreutils
    findutils
    diffutils
    gnugrep
    gawk
    gnused
    gnutar
    gzip
    bzip2
    xz
    
    # File management
    file
    tree
    rsync
    
    # Network utilities
    curl
    wget
    openssh
    
    # Text editors
    nano
    vim
    
    # System monitoring
    htop
    
    # Archive tools
    zip
    unzip
    p7zip
    
    # Development basics
    git
    
    # Browser
    # Using zen-browser (configured via programs.zen-browser)
  ];

  programs.home-manager.enable = true;
}
