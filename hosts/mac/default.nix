# hosts/mac — nix-darwin system config for the Apple Silicon Mac (computer-3)
{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # mise has a test that asserts setuid bits are preserved, but the darwin Nix
  # sandbox strips setuid/setgid bits by policy, so that one test always fails.
  # Skip just that test so mise can be built/managed through nix.
  nixpkgs.overlays = [
    (final: prev: {
      mise = prev.mise.overrideAttrs (old: {
        checkFlags = (old.checkFlags or [ ]) ++ [
          "--skip=oci::layer::tests::preserve_metadata_dir_layer_keeps_special_permission_bits"
        ];
      });
    })
  ];

  # Nix itself is managed by the official installer's daemon, not nix-darwin.
  # (Avoids nix-darwin trying to take over the existing daemon / nix.conf.)
  nix.enable = false;

  # Required for homebrew + system.defaults user-scoped options.
  system.primaryUser = "jack";
  users.users.jack = {
    name = "jack";
    home = "/Users/jack";
  };

  # Make zsh a system shell so /etc/zshrc sources home-manager session vars.
  programs.zsh.enable = true;

  # Homebrew — declaratively manage GUI casks (brew still does the install).
  # Conservative for now: no auto-upgrade/zap until the full cask list is ported.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # "zap" runs `brew bundle --cleanup --zap`, which also *untaps* any
      # repository not listed in `taps` below. That's fine as long as every tap
      # we rely on is declared here (e.g. kegworks-app/kegworks) — otherwise it
      # gets removed on each rebuild and has to be re-added by hand.
      cleanup = "zap";
    };
    taps = [
      "artginzburg/tap"
      "felixkratz/formulae"
      "grishka/grishka"
      "kegworks-app/kegworks" # provides the kegworks cask
      "mediosz/tap"
      "nikitabobko/tap"
      "oven-sh/bun"
      "sikarugir-app/sikarugir"
    ];
    brews = [
      "artginzburg/tap/sudo-touchid"
      "cmatrix"
      "docker-compose"
      "felixkratz/formulae/borders"
      "firebase-cli"
      "flyctl"
      "gemini-cli"
      "gnu-tar"
      "ispell"
      "libxml2"
      "mariadb"
      "osmium-tool"
      "oven-sh/bun/bun"
      "pandoc"
      "qemu"
      "scrcpy"
      "tmux"
      "uv"
      "virt-manager"
      "yt-dlp"
    ];
    casks = [
      # terminal / editors / dev
      "iterm2"
      "visual-studio-code"
      "jetbrains-toolbox"
      "antigravity"
      "postman"
      "docker-desktop"
      "utm"
      "vmware-fusion"
      # Casks from third-party taps are fully-qualified (user/tap/token) so
      # nix-darwin's `trusted: true` actually persists to Homebrew's trust store
      # — a bare token can't be trusted, so the tap stays untrusted and the cask
      # refuses to load until re-authorized after every rebuild.
      "kegworks-app/kegworks/kegworks"
      "playcover-community"
      # browsers
      "google-chrome"
      "zen"
      "helium-browser"
      "browseros"
      # ai / tooling
      "claude-code@latest"
      "codex"
      "codex-app"
      "t3-code"
      "lm-studio"
      # productivity / notes
      "obsidian"
      "libreoffice"
      "basictex"
      "launchcontrol"
      # communication
      "discord"
      "microsoft-teams"
      "whatsapp"
      # media / creative
      "obs"
      "droidcam-obs" # use phone as a camera in OBS (depends on obs)
      "audacity"
      "iina"
      "krita"
      "inkscape"
      "pinta"
      "aria-maestosa"
      # window mgmt / system utils
      "nikitabobko/tap/aerospace"
      "aldente"
      "jordanbaird-ice"
      "linearmouse"
      "logi-options+"
      "stats"
      "shottr"
      "keka"
      "grandperspective"
      "raspberry-pi-imager"
      "balenaetcher"
      # 3d printing / making  (autodesk-fusion omitted: its installer can't run
      # unattended via brew bundle — install it manually)
      "orcaslicer"
      "pronterface"
      "orange"
      # devices / connectivity
      "android-platform-tools"
      "vysor"
      "grishka/grishka/neardrop"
      "sonos"
      # gaming
      "steam"
      "minecraft"
      # fonts / X11 / misc
      "font-source-code-pro"
      "xquartz"
      "miniconda"
      "microsoft-auto-update"
    ];
  };

  system.stateVersion = 6;
}
