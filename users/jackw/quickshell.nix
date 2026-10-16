# users/jackw/quickshell.nix
# Hayashi's Quickshell shell, from the hayashi flake. Started from Hyprland
# (see hyprland.nix); `qs ipc call panels toggle` is bound to Super+Esc.
{ inputs, ... }:

{
  imports = [ inputs.hayashi.homeManagerModules.hayashi-shell ];

  programs.hayashi-shell = {
    enable = true;
    # Link the working copy so QML edits reload live without a rebuild.
    devPath = "/home/jackw/Documents/hayashi/shell";
  };
}
