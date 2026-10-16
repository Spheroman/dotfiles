# users/jackw/quickshell.nix
# Card and Base, the Quickshell shell in ./quickshell. Started from Hyprland
# (see hyprland.nix); `qs ipc call panels toggle` is bound to Super+Esc.
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
    material-symbols
    nerd-fonts.space-mono
    (google-fonts.override { fonts = [ "SpaceGrotesk" ]; })
  ];

  fonts.fontconfig.enable = true;

  # Out of the store so Quickshell hot-reloads edits without a rebuild.
  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink "/etc/nixos/users/jackw/quickshell";
}
