{
  description = "NixOS Configurations for all daudi.dev infrastructure";
  nixConfig = {
    substituters = [ ];
  };
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
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
      nixpkgs,
      home-manager,
      nix-flatpak,
      ...
    }:
    with (import ./.);
    {
      nixosConfigurations = {
        cambridge = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            (
              { lib, ... }:
              {
                nixpkgs = {
                  config = {
                    cudaSupport = true;
                    replaceStdenv = ({ pkgs }: (pkgs.withCFlags "-pipe -O3" (pkgs.impureUseNativeOptimizations (pkgs.useMoldLinker pkgs.gccStdenv))));
		  };
                };
              }
            )
            overlays
            hosts.default_mixins
            hosts.cambridge
            users.daudi
            {
              users.daudi.graphical = true;
            }
          ];
        };
        minecraft-server = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            hosts.default_mixins
            hosts.mixins.ssh-support
            hosts.minecraft-server
            home-manager.nixosModules.home-manager
            users.daudi
          ];
        };
      };
    };
}
