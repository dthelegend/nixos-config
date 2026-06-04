{ config, lib, pkgs, ... }:

let
  network = import ../network.nix;
  hostConfig = network.hosts.accra;
in
{
  networking = {
    hostName = "accra";
    interfaces = {
      "${hostConfig.interface}" = {
        ipv4.addresses = [
          {
            address = hostConfig.ip;
            prefixLength = hostConfig.prefixLength;
          }
        ];
      };
    };
    defaultGateway = {
      address = hostConfig.gateway;
      interface = hostConfig.interface;
    };

    firewall = {
      enable = true;
      # Open port 5000 for nix-serve binary cache, and port 22 for remote builds/SSH
      allowedTCPPorts = [ 5000 22 ];
    };
  };
}
