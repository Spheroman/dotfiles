{
  description = "Jack's NixOS Configuration";

  nixConfig = {
    extra-substituters = ["https://cache.soopy.moe"];
    extra-trusted-public-keys = ["cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="];
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

  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs:
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
            users.jackw = import ./home;
          };
        }

        # Solaar for Logitech devices
        inputs.solaar.nixosModules.default
      ];

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
      };
    };
}
