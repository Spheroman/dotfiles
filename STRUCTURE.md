# NixOS Configuration Structure

This document explains the organization of the NixOS configuration in `/etc/nixos`.

## Directory Layout

```
/etc/nixos/
├── flake.nix              # Entry point - defines all system configurations
├── flake.lock             # Locked dependency versions
│
├── hosts/                 # Machine-specific configurations
│   ├── desktop/           # Desktop workstation
│   │   ├── default.nix    # Desktop-specific settings, imports modules
│   │   └── hardware-configuration.nix  # Auto-generated hardware config
│   ├── laptop/            # MacBook with T2 chip (NixOS)
│   │   ├── default.nix    # Laptop-specific settings, T2 fixes
│   │   └── hardware-configuration.nix
│   ├── mac/               # Apple Silicon Macs (nix-darwin, not NixOS)
│   │   ├── common.nix     # Shared: homebrew base, overlays, user
│   │   ├── personal.nix   # computer-3 — games, personal-license apps
│   │   └── work.nix       # work — safer homebrew cleanup, no games
│   └── minimal/           # TTY-only fallback configuration
│       └── default.nix
│
├── modules/               # Reusable NixOS modules
│   ├── core/
│   │   └── default.nix    # Shared settings: locale, networking, users, fonts
│   ├── desktop/
│   │   ├── hyprland.nix   # Hyprland compositor + Wayland packages
│   │   ├── greetd.nix     # Login manager
│   │   ├── cosmic.nix     # COSMIC desktop option
│   │   └── kde.nix        # KDE Plasma option (unused)
│   └── hardware/
│       └── nvidia.nix     # NVIDIA drivers + CUDA configuration
│
└── users/                 # Home Manager user configurations
    ├── jackw/
    │   ├── default.nix    # User entry point, imports all modules
    │   ├── shell.nix      # Zsh, starship, zoxide, direnv
    │   ├── hyprland.nix   # Hyprland keybinds, rofi, mako, hyprlock
    │   ├── waybar.nix     # Status bar configuration
    │   ├── secrets.nix    # sops-nix secrets management
    │   ├── programs/
    │   │   ├── foot.nix    # Terminal emulator
    │   │   └── default.nix  # Git, Zen browser settings
    │   └── packages/
    │       ├── cli.nix         # CLI tools (ripgrep, fzf, eza, etc.)
    │       ├── development.nix # Dev tools (neovim, PyCharm, Python)
    │       └── applications.nix # GUI apps (Discord, Obsidian, etc.)
    │
    └── wenyu/
        ├── default.nix    # User entry point
        ├── shell.nix      # Zsh config (same features as jackw)
        ├── foot.nix       # Terminal config
        ├── hyprland.nix   # Hyprland settings
        └── programs/
            └── default.nix  # Git, Zen browser
```

## Key Concepts

### Flake Structure

The `flake.nix` defines 3 system configurations:
- **nixos** → Desktop with NVIDIA GPU
- **laptop** → MacBook with T2 chip
- **nixos-minimal** → TTY fallback (no GUI)

### Module Hierarchy

```mermaid
graph TD
    F[flake.nix] --> D[hosts/desktop]
    F --> L[hosts/laptop]
    F --> M[hosts/minimal]
    
    D --> C[modules/core]
    D --> H[modules/desktop/hyprland]
    D --> N[modules/hardware/nvidia]
    
    L --> C
    L --> H
    
    C --> HM[home-manager]
    HM --> J[users/jackw]
    HM --> W[users/wenyu]
```

### What Goes Where

| Category | Location | Example |
|----------|----------|---------|
| System-wide settings | `modules/core/` | Timezone, locale, system users |
| Desktop environment | `modules/desktop/` | Hyprland, greetd, Wayland |
| Hardware drivers | `modules/hardware/` | NVIDIA, GPU settings |
| Machine-specific | `hosts/<machine>/` | Hostname, kernel params |
| User packages | `users/<user>/packages/` | CLI tools, apps |
| User dotfiles | `users/<user>/*.nix` | Shell, terminal config |

## Common Tasks

### Adding a new package for jackw
Edit `users/jackw/packages/cli.nix`, `development.nix`, or `applications.nix`

### Adding a system-wide package
Edit `modules/core/default.nix` → `environment.systemPackages`

### Adding a new user
1. Create `users/<username>/` with `default.nix`
2. Add to `flake.nix` under `home-manager.users.<username>`
3. Add system user in `modules/core/default.nix`

### Switching configurations
```bash
rebuild              # Switch current machine
rebuild-desktop      # Explicitly use desktop config
rebuild-laptop       # Explicitly use laptop config
```

## macOS (nix-darwin)

Macs are built by the `mkDarwin` helper in `flake.nix` rather than declared
one at a time:

```nix
computer-3 = mkDarwin {
  hostname = "computer-3";
  gitEmail = "jackwen04@gmail.com";
  extraModules = [ ./hosts/mac/personal.nix ];
};
```

| Argument | Default | Purpose |
|----------|---------|---------|
| `hostname` | — | Flake attr to rebuild against; also fills the `rebuild` alias |
| `username` | `"jack"` | Drives `system.primaryUser`, `users.users.*`, home dir |
| `hostPlatform` | `"aarch64-darwin"` | Set `x86_64-darwin` for an Intel Mac |
| `gitEmail` | `null` | Per-host git identity; `null` leaves `user.email` unset, forcing per-repo config |
| `extraModules` | `[ ]` | Per-host modules layered on `hosts/mac/common.nix` |

Homebrew's `taps`/`brews`/`casks` are list options, so per-host files **add**
to the shared set in `common.nix` — they never replace it. Anything that
should exist on only one machine goes in that machine's file.

`onActivation.cleanup` is `mkDefault "zap"` in `common.nix` (removes anything
undeclared *and* deletes its data and untaps repos). `work.nix` lowers it to
`"uninstall"`, because a machine where software may be installed out-of-band
shouldn't have a rebuild silently eat it.

Adding a Mac is one entry in `darwinConfigurations`. Rebuild with
`darwin-rebuild switch --flake ~/dotfiles#<hostname>` (the `rebuild` alias is
already host-correct).
