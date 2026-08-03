# users/jackw/home-darwin.nix
# macOS home-manager config, shared by every Mac. Standalone for now; will be
# merged with the NixOS jackw config via platform guards in a later refactor.
#
# `hostname`, `username`, and `gitEmail` come from mkDarwin in flake.nix.
{ pkgs, lib, hostname, username, gitEmail, ... }:

{
  imports = [
    ./neovim.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # Extra PATH/env parity with the pre-nix shell.
  home.sessionVariables = {
    PNPM_HOME = "$HOME/Library/pnpm";
    HOMEBREW_PREFIX = "/opt/homebrew";
    HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
    HOMEBREW_REPOSITORY = "/opt/homebrew";
  };
  # These go into hm-session-vars (sourced before .zshrc), so `mise activate`
  # in .zshrc prepends its shims AFTER homebrew and wins (e.g. mise node over
  # the homebrew node that's pulled in as a brew dependency).
  home.sessionPath = [
    "$HOME/Library/pnpm"
    "$HOME/Library/pnpm/bin" # pnpm binary lives here in this install layout
    "$HOME/.antigravity/antigravity/bin"
    "$HOME/.lmstudio/bin"
    "$HOME/.pub-cache/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

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
      rebuild = "darwin-rebuild switch --flake ~/dotfiles#${hostname}";
    };

    # fzf-tab fixups (brew is now on PATH via sessionPath, above).
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

  # mise (nix-managed, sandbox test patched in hosts/mac overlay) handles
  # language runtimes; uv handles Python.
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  # No git@github insteadOf on macOS: there's no SSH key here, so push/fetch
  # over HTTPS via the gh/osxkeychain credential helper instead.
  #
  # Each host supplies its own identity via mkDarwin's `gitEmail`, so work
  # commits are attributed to the work address rather than the personal one.
  # Passing `gitEmail = null` instead leaves user.email unset, which makes git
  # refuse to commit until it's set per-repo — useful for a machine where no
  # single default identity is right.
  programs.git = {
    enable = true;
    settings.user = {
      # Merge at the `user` level: `//` is shallow, so merging whole `settings`
      # attrsets here would drop `name` on any host that supplies an email.
      name = "Jack Wen";
    } // lib.optionalAttrs (gitEmail != null) {
      email = gitEmail;
    };
  };

  home.packages = with pkgs; [
    # core CLI
    eza
    bat
    ripgrep
    fd
    jq
    yq-go
    tree
    file
    which
    btop
    fastfetch
    glow
    hugo
    # git / github
    gh
    # archives
    zip
    unzip
    xz
    zstd
    p7zip
    # networking
    nmap
    mtr
    iperf3
    aria2
    socat
    ipcalc
    dnsutils
    ldns
    # misc
    cowsay
    nnn
    gnupg
    # nix helpers
    nix-output-monitor
    nh
  ];
}
