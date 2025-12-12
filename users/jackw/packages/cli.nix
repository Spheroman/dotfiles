# users/jackw/packages/cli.nix
# CLI tools and utilities
{ pkgs, ... }:

{
  home.packages = with pkgs; [
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

    # Misc utilities
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
    nh  # Better nixos-rebuild experience
    hugo
    glow
    fastfetch
  ];
}
