# home/default.nix
{ config, pkgs, lib, inputs, osConfig, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.beta
    ./programs
    ./shell.nix
    ./git.nix
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

  # Shared zsh/prompt/fzf config is in ./shell.nix; these add to it.
  programs.zsh = {
    shellAliases = {
      rebuild = "nh os switch /etc/nixos";
      rebuild-desktop = "nh os switch /etc/nixos -H nixos";
      rebuild-laptop = "nh os switch /etc/nixos -H laptop";
      rebuild-test = "nh os test /etc/nixos";
      update-flake = "nix flake update --flake /etc/nixos";
    };

    # Appended, so nix-provided binaries win over anything dropped in here.
    initContent = ''
      export ZSH_DISABLE_COMPFIX="true"
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
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
