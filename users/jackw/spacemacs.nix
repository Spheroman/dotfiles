{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    git
    ripgrep
    fd
    clang
    cmake
    gnumake
    libtool
    source-code-pro
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: with epkgs; [
      gnu-elpa-keyring-update
    ];
  };

  home.activation.installSpacemacs = config.lib.dag.entryAfter ["writeBoundary"] ''
    # Clone Spacemacs if .emacs.d doesn't exist
    if [ ! -d "$HOME/.emacs.d" ]; then
      ${pkgs.git}/bin/git clone -b develop https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
    fi

    # Symlink .spacemacs to the file in nixos-config
    # This allows Spacemacs to edit the file directly in the repo
    if [ -f "/etc/nixos/users/jackw/files/.spacemacs" ]; then
      ln -sf "/etc/nixos/users/jackw/files/.spacemacs" "$HOME/.spacemacs"
    fi
  '';
}
