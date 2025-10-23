{
  description = "A simple NixOS flake";

  nixConfig = {
    extra-substituters = ["https://cache.soopy.moe"];
    extra-trusted-public-keys = ["cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="];
  };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, zen-browser, solaar ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
          ./hardware-desktop.nix

          solaar.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

          # Pass inputs to all home-manager modules
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.jackw = import ./home.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
          ./hardware-laptop.nix

          nixos-hardware.nixosModules.apple-t2
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

          # Pass inputs to all home-manager modules
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.jackw = import ./home.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
