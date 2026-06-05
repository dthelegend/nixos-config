{ modulesPath, config, lib, pkgs, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../lxc-restriction.nix
    ./connectivity.nix
    ./forgejo.nix
  ];

  # Platform Architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "25.11";
}
