# users/jackw/home-darwin.nix
# First-cut macOS home-manager config. Mirrors today's manual zsh setup.
# Will be refactored to share modules with the NixOS jackw config later.
{ pkgs, ... }:

{
  home.username = "jack";
  home.homeDirectory = "/Users/jack";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = false; # the non-wonky behavior
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "gh" "fzf" "sudo" "colored-man-pages" ];
    };

    shellAliases = {
      ll = "eza -la --icons --git";
      la = "eza -a --icons";
      lt = "eza --tree --icons -L 2";
      cat = "bat";
      rebuild = "darwin-rebuild switch --flake ~/dotfiles#computer-3";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # mise (managed by nix, with the sandbox-incompatible test patched out via
  # the overlay in hosts/mac) handles language runtimes; uv handles Python.
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Jack Wen";
      user.email = "jackwen04@gmail.com";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  home.packages = with pkgs; [
    eza
    bat
    ripgrep
    fd
    jq
    gh
    fastfetch
  ];
}
