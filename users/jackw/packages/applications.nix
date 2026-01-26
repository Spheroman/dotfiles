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
    qimgv

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

    # BrowserOS
    (appimageTools.wrapType2 {
      pname = "browseros";
      version = "0.28.1";
      src = fetchurl {
        url = "https://github.com/browseros-ai/BrowserOS/releases/download/v0.28.1/BrowserOS_v0.28.1_x64.AppImage";
        sha256 = "sha256-YY3g0xNr/Jm4Q1PJSg27vO+M5jur/lM2a6iTN03BbCA=";
      };
    })

    # Chrome
    google-chrome
  ];
}
