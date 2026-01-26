# home/default.nix
{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.beta
    ./programs
    ./shell.nix
    ./hyprland.nix
    ./spacemacs.nix
    ./neovim.nix
    ./waybar.nix
    ./secrets.nix
    # Modular package organization
    ./packages/cli.nix
    ./packages/development.nix
    ./packages/applications.nix
  ];

  home = {
    username = "jackw";
    homeDirectory = "/home/jackw";
    stateVersion = "25.11";
  };



  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {cudaSupport = true;};
  };

  programs.home-manager.enable = true;
}
