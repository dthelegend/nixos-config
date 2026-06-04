{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./connectivity.nix
  ];

  # Hardware Architecture (Raspberry Pi - AArch64 bare metal)
  nixpkgs.hostPlatform = "aarch64-linux";

  # Raspberry Pi Bootloader (UEFI/Systemd-boot) and Filesystems
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXOS_BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Hardened OpenSSH Configuration
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    extraConfig = ''
      # Restrict SSH access to local network, link-local IPv6, and Tailscale subnets
      Match Address *,!192.168.1.0/24,!100.64.0.0/10,!fd7a:115c:a1e0::/48,!fe80::/10
          DenyUsers *
    '';
  };

  # Local DNS Sinkhole (Crab-hole)
  services.crab-hole = {
    enable = true;
    settings = {
      downstream = [
        {
          protocol = "udp";
          listen = "0.0.0.0";
          port = 53;
        }
        {
          protocol = "tcp";
          listen = "0.0.0.0";
          port = 53;
        }
      ];
    };
  };

  # Disable resolved stub listener to free port 53 for crab-hole
  services.resolved = {
    enable = true;
    extraConfig = ''
      DNSStubListener=no
    '';
  };

  system.stateVersion = "25.11";
}
