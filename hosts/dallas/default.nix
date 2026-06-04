{ modulesPath, config, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./connectivity.nix
    ./mc-server.nix
  ];

  # Platform Architecture
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
