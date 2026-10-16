# users/jackw/packages/applications.nix
# GUI applications
{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Communication
    discord
    teams-for-linux

    # Media
    noson

    # Productivity
    libreoffice-fresh
    hunspell
    hunspellDicts.en-us
    obsidian
    krita

    # Containers
    distrobox

    # Theming
    nwg-look

    # Chrome
    google-chrome
  ];
}
