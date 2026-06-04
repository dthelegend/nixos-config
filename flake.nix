{
  description = "NixOS Configurations for all daudi.dev infrastructure";
  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      home-manager,
      home-manager-stable,
      nix-flatpak,
      nix-minecraft,
      nixpkgs,
      nixpkgs-stable
    }:
    with (import ./.);
    {
      nixosConfigurations = {
        cambridge = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            nix-flatpak = nix-flatpak;
            home-manager = home-manager;
          };
          modules = [
            overlays
            hosts.default-mixins
            hosts.cambridge
            users.daudi
            {
              users.daudi.graphical = true;
            }
          ];
        };
        milton-keynes = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            nix-flatpak = nix-flatpak;
            home-manager = home-manager-stable;
          };
          modules = [
            hosts.default-mixins
            hosts.milton-keynes
            users.daudi
            {
              users.daudi.graphical = true;
            }
          ];
        };
        dar-es-salaam = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            nix-flatpak = nix-flatpak;
            home-manager = home-manager-stable;
          };
          modules = [
            hosts.default-mixins
            hosts.dar-es-salaam
            users.daudi
          ];
        };
        accra = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            nix-flatpak = nix-flatpak;
            home-manager = home-manager-stable;
          };
          modules = [
            hosts.default-mixins
            hosts.accra
            users.daudi
          ];
        };
        dallas = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            nix-flatpak = nix-flatpak;
            nix-minecraft = nix-minecraft;
            home-manager = home-manager-stable;
          };
          modules = [
            hosts.default-mixins
            hosts.mixins.ssh-support
            hosts.dallas
            users.daudi
          ];
        };
      };
    };
}
