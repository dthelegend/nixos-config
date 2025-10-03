{
  modulesPath,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
