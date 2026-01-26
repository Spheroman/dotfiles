# home/shell.nix
{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    initExtra = ''
      export ZSH_DISABLE_COMPFIX="true"
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      
      # Only run fastfetch in interactive shells and if it exists
      if [[ -o interactive ]] && command -v fastfetch >/dev/null; then
        fastfetch
      fi

      # Better history search with up/down arrows
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    '';

    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      rossetup = "source /opt/ros/jazzy/setup.bash";

      # Nix helpers using nh
      rebuild = "nh os switch /etc/nixos";
      rebuild-desktop = "nh os switch /etc/nixos -H nixos";
      rebuild-laptop = "nh os switch /etc/nixos -H laptop";
      rebuild-test = "nh os test /etc/nixos";
      update-flake = "nix flake update --flake /etc/nixos";

      # Common aliases
      ll = "eza -la --icons --git";
      la = "eza -a --icons";
      lt = "eza --tree --icons -L 2";
      cat = "bat";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "kubectl"
        "fzf"
        "sudo"
        "history"
        "colored-man-pages"
      ];
    };
  };

  # Zoxide - smarter cd command
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Starship - customizable prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch.symbol = " ";
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };
    };
  };

  # Direnv - per-project environment management
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;  # Use nix-direnv for faster nix integration
  };

  # Install bat for better cat alias
  home.packages = with pkgs; [
    bat
  ];
}

