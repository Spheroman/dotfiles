# users/jackw/shell.nix
# zsh + prompt + shell tooling, shared by NixOS and the Macs.
#
# Platform-specific bits (PATH entries, `rebuild`, mise on the Macs) live in
# the entry files: users/jackw/default.nix and users/jackw/home-darwin.nix.
# shellAliases and initContent merge across modules, so they just add to this.
{ pkgs, ... }:

{
  home.sessionVariables.BAT_PAGER = "less -R --mouse";

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

    # fzf-tab: fuzzy tab completion with previews.
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "gh" "fzf" "sudo" "colored-man-pages" ];
    };

    shellAliases = {
      ll = "eza -la --icons --git";
      la = "eza -a --icons";
      lt = "eza --tree --icons -L 2";
      cat = "bat";
      cc = "claude --dangerously-skip-permissions";
      urldecode = "uv run -q --no-project python -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "uv run -q --no-project python -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };

    initContent = ''
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 "$realpath"'

      # fzf's zsh integration rebinds Tab to its own completion; re-enable
      # fzf-tab afterwards so it owns Tab.
      enable-fzf-tab
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      command_timeout = 1000;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch.symbol = " ";
      aws.disabled = true;
      gcloud.disabled = true;
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
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" ];
  };

  # Targets of the aliases above.
  home.packages = with pkgs; [
    eza
    bat
  ];
}
