# dotfiles

Nix configuration for every machine I use: NixOS on the desktop and the T2
MacBook, nix-darwin + home-manager on the Apple Silicon Macs.

See [STRUCTURE.md](STRUCTURE.md) for how the repo is laid out and where a given
setting belongs.

## Machines

| Flake attr | Machine | Notes |
|------------|---------|-------|
| `nixos` | Desktop workstation | NVIDIA, Hyprland |
| `laptop` | MacBook with T2 chip | NixOS, T2 fixes |
| `nixos-minimal` | TTY fallback | No GUI |
| `computer-3` | Personal Apple Silicon Mac | nix-darwin |
| `work` | Card store Mac | nix-darwin |

## Installing on a new Mac

Both Macs run the same base config; they differ only in the app list, the
Homebrew cleanup policy, and the git identity.

### 1. Xcode command line tools

Needed for `git` and Homebrew.

```bash
xcode-select --install
```

### 2. Nix

Use the Determinate Systems installer — the existing Macs were installed this
way, and `hosts/mac/common.nix` sets `nix.enable = false` on the assumption
that the installer's daemon (not nix-darwin) owns `/etc/nix/nix.conf`.

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
exec $SHELL -l   # or open a new terminal
```

### 3. Homebrew

nix-darwin manages *which* casks are installed, but does not install Homebrew
itself.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 4. Clone this repo

```bash
git clone https://github.com/Spheroman/dotfiles ~/dotfiles
cd ~/dotfiles && git checkout darwin
```

The path matters: the `rebuild` alias points at `~/dotfiles`.

### 5. First switch

`darwin-rebuild` isn't on `PATH` until the first generation exists, so run it
out of the flake. Substitute the right host attr.

```bash
sudo nix run nix-darwin -- switch --flake ~/dotfiles#computer-3   # personal
sudo nix run nix-darwin -- switch --flake ~/dotfiles#work         # card store
```

Afterwards, `rebuild` (aliased per host) handles every subsequent change.

### 6. Post-install

- `gh auth login` — git uses HTTPS with the `gh`/osxkeychain credential helper;
  there's no SSH key on the Macs.
- Install `autodesk-fusion` by hand. It's deliberately not in the cask list:
  its installer can't run unattended under `brew bundle`.
- Expect `*.hm-backup` files if the machine already had a `~/.zshrc` and
  friends — home-manager renames rather than clobbers, per
  `backupFileExtension` in `flake.nix`.

## Adding another Mac

Machines are built by the `mkDarwin` helper, so a new one is a single entry:

```nix
newmac = mkDarwin {
  hostname = "newmac";
  gitEmail = "someone@example.com";
  extraModules = [ ./hosts/mac/personal.nix ];
};
```

Arguments are documented in [STRUCTURE.md](STRUCTURE.md#macos-nix-darwin).
Anything the machine should *not* share goes in its own `hosts/mac/*.nix`;
Homebrew's `taps`/`brews`/`casks` are list options, so per-host files add to
the shared set rather than replacing it.

Note that Nix only sees git-tracked files: `git add` a new host file before
rebuilding, or evaluation fails with "path ... is not tracked by Git".

## Homebrew cleanup

`hosts/mac/common.nix` defaults `homebrew.onActivation.cleanup` to `"zap"`,
which uninstalls anything not declared in the config, deletes its support
files and preferences, and untaps repositories not listed in `taps`. That's
intentional on a personal machine — it keeps the config honest.

`hosts/mac/work.nix` lowers it to `"uninstall"`. On a machine where software
may be installed out-of-band (a vendor tool, a printer or label driver, a
one-off install between rebuilds), `"zap"` would delete it *and its data*, and
the breakage would surface at the next unrelated rebuild rather than at
install time. When such a tool becomes permanent, declare it in `work.nix`.
