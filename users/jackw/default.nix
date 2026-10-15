# home/default.nix
{ config, pkgs, lib, inputs, osConfig, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.beta
    ./programs
    ./shell.nix
    ./hyprland.nix
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
    # CUDA only where the host actually has the NVIDIA driver
    package = pkgs.obs-studio.override {
      cudaSupport = lib.elem "nvidia" osConfig.services.xserver.videoDrivers;
    };
  };

  programs.home-manager.enable = true;
}
