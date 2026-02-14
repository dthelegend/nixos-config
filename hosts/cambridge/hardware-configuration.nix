{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  globals,
  ...
}:

{
  _module.args = { inherit inputs globals; };

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "thunderbolt"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1252d8b9-d1d4-4c83-9e30-16e2e661680e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0DBC-98A1";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b124ac79-d4cd-4bff-bcd6-64baa4672764"; }
  ];

  # One day my son...
  # nixpkgs.config.replaceStdenv = ({ pkgs }: pkgs.impureUseNativeOptimizations (pkgs.useMoldLinker (pkgs.withCFlags "-pipe -O3" pkgs.stdenv)));
  nixpkgs.config.enableParallelBuildingByDefault = true;
  nixpkgs.config.cudaSupport = true;
  nixpkgs.hostPlatform = lib.mkDefault {
    system = "x86_64-linux";
    config = "x86_64-unknown-linux-gnu";
    gcc = {
      arch = "znver5";
      tune = "znver5";
    };
  };
  nix.settings.max-jobs = 1;
  nix.settings.cores = 16;
  nix.settings.substituters = [ ];
  nix.settings.trusted-substituters = [ ];
  nix.settings.system-features = [
    "nixos-test"
    "benchmark"
    "big-parallel"
    "kvm"
    "gccarch-znver5"
  ];
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
