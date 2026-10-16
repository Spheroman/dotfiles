# dotfiles

Nix configuration for every machine I use: NixOS on the desktop, the T2
MacBook, and any new PC, nix-darwin + home-manager on the Apple Silicon Macs.

See [STRUCTURE.md](STRUCTURE.md) for how the repo is laid out and where a given
setting belongs.

## Machines

| Flake attr | Machine | Notes |
|------------|---------|-------|
| `nixos` | Desktop workstation | NVIDIA, Hyprland |
| `laptop` | MacBook with T2 chip | NixOS, T2 fixes |
| `generic` | Any new x86_64 PC | Desktop's apps, no GPU/hardware specifics |
| `yoga` | Lenovo Yoga 7 2-in-1 (AMD) | `generic` + power profiles, battery charge limit |
| `nixos-minimal` | TTY fallback | No GUI |
| `computer-3` | Personal Apple Silicon Mac | nix-darwin |
| `work` | Card store Mac | nix-darwin |

## Installing on a new NixOS machine

`generic` is the desktop config with the hardware stripped out: same Hyprland /
COSMIC session, services, users, and apps, but no NVIDIA module, no swap file,
and no disk layout. The only machine-specific file is the
`hardware-configuration.nix` you generate during the install. The machine needs
to boot in UEFI mode (the config uses systemd-boot).

### 1. Boot the installer

Boot the [NixOS ISO](https://nixos.org/download/) (the minimal one is enough)
and get online. Ethernet works on its own; for WiFi, run `nmtui`.

### 2. Partition and mount

Here's an example for a blank disk at `/dev/nvme0n1` (check with `lsblk`, and
change the device name if yours is different). **It erases the disk.**

```bash
sudo -i
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart root ext4 1GiB 100%
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/nvme0n1p2
mount /dev/disk/by-label/nixos /mnt
mount --mkdir -o umask=077 /dev/disk/by-label/boot /mnt/boot
```

### 3. Generate the hardware config and clone this repo

```bash
nixos-generate-config --root /mnt
mv /mnt/etc/nixos /mnt/etc/nixos.generated
nix-shell -p git --run 'git clone https://github.com/Spheroman/dotfiles /mnt/etc/nixos'
cd /mnt/etc/nixos && git checkout darwin
cp /mnt/etc/nixos.generated/hardware-configuration.nix hosts/generic/
git add hosts/generic/hardware-configuration.nix
```

The `git add` is required. Nix only sees files tracked by git, so leaving it
out fails with an error about `fileSystems."/"` not being set. The repo has to
live at `/etc/nixos`, because the `rebuild` aliases point there.

Optional: to give the machine its own name, rename the `generic` attr in
`flake.nix` and set `networking.hostName` to the same value in
`hosts/generic/default.nix`. `rebuild` (nh) picks the config whose name matches
the hostname, so the two have to agree. You can also copy `hosts/generic` to a
new `hosts/<name>` directory and add a matching `nixosConfigurations` entry.

### 4. Install

```bash
nixos-install --flake /mnt/etc/nixos#generic
```

At the end it asks for a root password. Then `reboot`.

### 5. Post-install

- Log in as `jackw` (the initial password is `jackw`) and run `passwd` right
  away. Do the same for `wenyu`.
- Take ownership of the repo so you can commit to it without sudo:
  `sudo chown -R jackw /etc/nixos`.
- Run `gh auth login`. Git reaches GitHub over HTTPS with gh as the
  credential helper.
- Copy the age key to `~/.config/sops/age/keys.txt` (mode 600) so sops-nix
  can install the SSH keys and tokens; see `users/jackw/secrets.nix`.
- Give the machine its own host rather than committing its hardware config
  into `hosts/generic`, which has to stay a template: copy `hosts/generic` to
  `hosts/<name>`, move `hardware-configuration.nix` there, set
  `networking.hostName`, and add a matching `nixosConfigurations` entry
  (`hosts/yoga` is an example). Switch once with
  `nh os switch /etc/nixos -H <name>`; after that, `rebuild` handles every
  later change.
- If the machine has an NVIDIA GPU, add `../../modules/hardware/nvidia.nix` to
  the host's imports. OBS picks up CUDA support automatically when the
  NVIDIA driver is enabled.

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
