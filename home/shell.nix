# home/shell.nix
{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      rossetup = "source /opt/ros/jazzy/setup.bash";

      # Nix helpers
      rebuild-desktop = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
      rebuild-laptop = "sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      rebuild-test = "sudo nixos-rebuild test --flake ~/nixos-config";
      update-flake = "nix flake update ~/nixos-config";
    };
  };
}
