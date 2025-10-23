{
  description = "A simple NixOS flake";

  nixConfig = {
    extra-substituters = ["https://cache.soopy.moe"];
    extra-trusted-public-keys = ["cache.soopy.moe-1:0RZVsQeR+GOh0VQI9rvnHz55nVXkFardDqfm4+afjPo="];
  };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    T2FanRD.url = "github:GnomedDev/T2FanRD";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    solaar = {
      url = "github:Svenum/Solaar-Flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };


  outputs = inputs@{ nixpkgs, nixos-hardware, T2FanRD, home-manager, zen-browser, solaar, hyprland, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/hardware-desktop.nix

          solaar.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

          # Pass inputs to all home-manager modules
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.jackw = import ./home/user.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/hardware-laptop.nix

          nixos-hardware.nixosModules.apple-t2
          solaar.nixosModules.default
          home-manager.nixosModules.home-manager
          T2FanRD.nixosModules.t2fanrd

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

          # Pass inputs to all home-manager modules
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.jackw = import ./home/user.nix;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
