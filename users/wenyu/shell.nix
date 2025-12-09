# home/shell.nix
{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
    '';

    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

      # Nix helpers
      rebuild-desktop = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      rebuild-laptop = "sudo nixos-rebuild switch --flake /etc/nixos#laptop";
      rebuild-test = "sudo nixos-rebuild test --flake /etc/nixos";
      update-flake = "nix flake update /etc/nixos";
    };
  };
}
