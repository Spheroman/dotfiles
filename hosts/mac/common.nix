# hosts/mac/common.nix — settings shared by every Mac.
#
# Per-machine divergence (app list, homebrew cleanup policy) lives in
# hosts/mac/personal.nix and hosts/mac/work.nix, which are appended by the
# `mkDarwin` helper in flake.nix. Homebrew's tap/brew/cask options are lists,
# so those files *add* to what's here rather than replacing it.
{ pkgs, lib, username, hostPlatform, ... }:

{
  nixpkgs.hostPlatform = hostPlatform;
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
  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Make zsh a system shell so /etc/zshrc sources home-manager session vars.
  programs.zsh.enable = true;

  # Homebrew — declaratively manage GUI casks (brew still does the install).
  homebrew = {
    enable = true;
    onActivation = {
      # Runs `brew update` before the bundle. Costs 10-30s per rebuild, but
      # without it Homebrew's own version only moves when updated by hand, and
      # once it drifts far enough behind the cask API every rebuild dies at
      # this step with "undefined method '...' for Cask" — which aborts
      # activation partway, before /run/current-system is updated.
      autoUpdate = true;
      # Still no automatic package upgrades: only Homebrew itself moves.
      upgrade = false;
      # Set per host. "zap" runs `brew bundle --cleanup --zap`, which removes
      # anything not listed below *and* deletes its support files and prefs —
      # and it untaps any repository not named in `taps`. Good for keeping a
      # personal machine honest, hazardous where software might be installed
      # out-of-band; see hosts/mac/work.nix.
      cleanup = lib.mkDefault "zap";
    };
    # Casks from third-party taps are fully-qualified (user/tap/token) so
    # nix-darwin's `trusted: true` actually persists to Homebrew's trust store
    # — a bare token can't be trusted, so the tap stays untrusted and the cask
    # refuses to load until re-authorized after every rebuild.
    taps = [
      "artginzburg/tap" # sudo-touchid
      "felixkratz/formulae" # borders
      "grishka/grishka" # neardrop
      "mediosz/tap"
      "nikitabobko/tap" # aerospace
      "oven-sh/bun" # bun
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
      "antigravity"
      "postman"
      "docker-desktop"
      "utm"
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
      # fonts / X11 / misc
      "font-source-code-pro"
      "xquartz"
      "miniconda"
      "microsoft-auto-update"
    ];
  };

  # Start-at-login, declaratively.
  #
  # macOS login items live in the per-machine SMAppService database, not in
  # any file, so they don't survive to a new Mac — which is why AeroSpace
  # didn't autostart there despite `start-at-login = true` in aerospace.toml.
  # That setting only tells AeroSpace to register itself once it has been
  # launched by hand; it's now false, and launchd owns startup instead.
  #
  # RunAtLoad without KeepAlive matches login-item behaviour: started at
  # login, but quitting the app keeps it quit until next login.
  #
  # borders is deliberately absent — aerospace.toml already launches it via
  # `after-startup-command`, and a second agent would start it twice.
  launchd.user.agents = {
    aerospace = {
      serviceConfig = {
        ProgramArguments = [ "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" ];
        RunAtLoad = true;
        ProcessType = "Interactive";
      };
    };
    ice = {
      serviceConfig = {
        ProgramArguments = [ "/Applications/Ice.app/Contents/MacOS/Ice" ];
        RunAtLoad = true;
        ProcessType = "Interactive";
      };
    };
    stats = {
      serviceConfig = {
        ProgramArguments = [ "/Applications/Stats.app/Contents/MacOS/Stats" ];
        RunAtLoad = true;
        ProcessType = "Interactive";
      };
    };
  };

  system.stateVersion = 6;
}
