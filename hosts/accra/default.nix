{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./connectivity.nix
  ];

  # Hardware/Platform Architecture (x86_64 VM on Proxmox VE)
  nixpkgs.hostPlatform = "x86_64-linux";

  # Bootloader and Filesystem (Standard VM setup)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # Binary Cache Server Configuration
  services.nix-serve = {
    enable = true;
    port = 5000;
    secretKeyFile = "/var/lib/nix-serve/cache-key.sec";
  };

  # Enable emulation of AArch64 to act as remote builder / compiler for dar-es-salaam
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "25.11";
}
