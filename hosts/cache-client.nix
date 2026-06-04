{ config, lib, pkgs, ... }:

let
  network = import ./network.nix;
  accraIp = network.hosts.accra.ip;
in
{
  options.custom = {
    useLocalCache = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use the local 'accra' cache node and compilation delegation.";
    };
  };

  config = lib.mkIf config.custom.useLocalCache {
    nix = {
      settings = {
        substituters = [
          "http://${accraIp}:5000"
        ];
        # Public key will be updated/configured by the user after running nix-store --generate-binary-cache-key
        trusted-public-keys = [
          "accra-1:ZfGfNZa5+Z2i+3b6N9/7Z7qG+P9E9D+S8vP9v9z9y9w="
        ];
      };
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = accraIp;
          system = "x86_64-linux";
          systems = [ "x86_64-linux" "aarch64-linux" ];
          maxJobs = 8;
          sshUser = "nix-builder";
          sshKey = "/root/.ssh/id_ed25519";
          supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        }
      ];
    };
  };
}
