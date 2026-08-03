{
  description = "Jack's NixOS Configuration";

  nixConfig = {
    extra-substituters = [
      "https://cache.soopy.moe"
    ];
    extra-trusted-public-keys = [
      "cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    T2FanRD.url = "github:GnomedDev/T2FanRD";

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS system management
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nix-darwin, ... }@inputs:
    let
      system = "x86_64-linux";

      # Shared configuration modules
      commonModules = [
        # Core system configuration
        ./modules/core

        # Enable flakes globally
        { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }

        # Home manager setup
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.jackw = import ./users/jackw;
            users.wenyu = import ./users/wenyu;
          };
        }

        # Solaar for Logitech devices
        inputs.solaar.nixosModules.default
      ];

      # One Mac. `extraModules` carries the per-host divergence (app list,
      # homebrew cleanup policy); everything else is shared via
      # hosts/mac/common.nix and users/jackw/home-darwin.nix.
      #
      # `gitEmail = null` leaves user.email unset, so git refuses to commit
      # until it's configured per-repo — deliberate on a machine where commits
      # belong to someone else.
      mkDarwin =
        { hostname
        , username ? "jack"
        , hostPlatform ? "aarch64-darwin"
        , gitEmail ? null
        , extraModules ? [ ]
        }:
        nix-darwin.lib.darwinSystem {
          system = hostPlatform;
          specialArgs = { inherit inputs hostname username hostPlatform; };
          modules = [
            ./hosts/mac/common.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-backup";
                extraSpecialArgs = { inherit inputs hostname username gitEmail; };
                users.${username} = import ./users/jackw/home-darwin.nix;
              };
            }
          ] ++ extraModules;
        };

    in {
      nixosConfigurations = {
        # Desktop configuration
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./hosts/desktop
          ];
        };

        # Laptop configuration
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./hosts/laptop
            nixos-hardware.nixosModules.apple-t2
            inputs.T2FanRD.nixosModules.t2fanrd
          ];
        };

        # Minimal fallback configuration (TTY only)
        nixos-minimal = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/minimal
            # Minimal config doesn't use home-manager or graphical environment
            { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }
          ];
        };
      };

      # macOS (Apple Silicon) — nix-darwin + home-manager
      darwinConfigurations = {
        # Personal Mac.
        computer-3 = mkDarwin {
          hostname = "computer-3";
          gitEmail = "jackwen04@gmail.com";
          extraModules = [ ./hosts/mac/personal.nix ];
        };

        # Card store work Mac. Keyed on the name "work" rather than the
        # machine's hostname, so `rebuild` is correct without having to rename
        # the box; change `hostname` here if you'd rather match it.
        work = mkDarwin {
          hostname = "work";
          gitEmail = "jack@tabletopvillage.com";
          extraModules = [ ./hosts/mac/work.nix ];
        };
      };
    };
}
