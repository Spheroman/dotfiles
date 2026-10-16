# users/jackw/quickshell.nix
# Hayashi's Quickshell shell, from the hayashi flake. Started from Hyprland
# (see hyprland.nix) and runs from the Nix store; it changes when the
# `hayashi` input is updated and the system is rebuilt.
#
# To work on it live: `hayashi-shell dev ~/Documents/hayashi/shell`
# (`hayashi-shell dev off` to go back).
{ inputs, ... }:

{
  imports = [ inputs.hayashi.homeManagerModules.hayashi-shell ];

  programs.hayashi-shell.enable = true;
}
