# users/jackw/home-darwin.nix
# macOS home-manager config, shared by every Mac. Shell and git config shared
# with NixOS come from ./shell.nix and ./git.nix; this file is what's Mac-only.
#
# `hostname`, `username`, and `gitEmail` come from mkDarwin in flake.nix.
{ config, pkgs, hostname, username, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./secrets-darwin.nix
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
    "$HOME/.lmstudio/bin"
    "$HOME/.pub-cache/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  # AeroSpace reads ~/.aerospace.toml directly; the cask comes from
  # hosts/mac/common.nix. Managed as a file rather than generated from Nix
  # so it stays a stock aerospace.toml that upstream docs apply to.
  home.file.".aerospace.toml".source = ./programs/aerospace.toml;

  # LinearMouse is configured through its GUI, which writes this file back —
  # a read-only store symlink would make its settings pane fail to save. Point
  # at the working tree so GUI changes land in the repo and show up in
  # `git status`, same as lazy-lock.json below.
  home.file.".config/linearmouse/linearmouse.json".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/users/jackw/programs/linearmouse.json";

  # lazy.nvim rewrites lazy-lock.json whenever plugins are installed or
  # updated, so this can't be a read-only store symlink — a fresh machine
  # would fail on first launch while installing plugins. mkOutOfStoreSymlink
  # points at the working tree instead, so :Lazy update edits the repo copy
  # directly and the change shows up in `git status`.
  #
  # This is the one place the config assumes the repo lives at ~/dotfiles.
  home.file.".config/nvim/lazy-lock.json".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/users/jackw/programs/lazy-lock.json";

  # Shared zsh/prompt/fzf config is in ./shell.nix; these add to it.
  programs.zsh.shellAliases = {
    # sudo is required: darwin-rebuild refuses to activate as non-root
    # ("system activation must now be run as root") rather than escalating
    # on its own. It re-drops to $SUDO_USER for the home-manager part.
    rebuild = "sudo darwin-rebuild switch --flake ~/dotfiles#${hostname}";
  };

  # mise (nix-managed) handles
  # language runtimes; uv handles Python.
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        java = "lts";
        node = "lts";
        ruby = "3";
        rust = "latest";
      };
      settings.idiomatic_version_file_enable_tools = [ "ruby" ];
    };
  };

  # Shared git/gh config is in ./git.nix; the keychain is the Mac-only part.
  programs.git.settings.credential.helper = "osxkeychain";

  home.packages = with pkgs; [
    # core CLI  (eza/bat come from ./shell.nix)
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
    # git / github  (gh comes from programs.gh, above)
    # dev
    supabase-cli # newgit's supabase template test runs `supabase init`
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
