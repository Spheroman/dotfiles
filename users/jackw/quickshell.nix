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

  # Apps learn light/dark from the desktop portal, which reads this
  # (Firefox/Zen, GTK 4 and libadwaita apps; the compositor isn't involved).
  # A leftover KDE/COSMIC value had it at prefer-light.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
