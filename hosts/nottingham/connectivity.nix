{ config, lib, pkgs, ... }:

let
  network = import ../network.nix;
  hostConfig = network.hosts.nottingham;
in
{
  networking = {
    hostName = "nottingham";
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
      # Open port 22 for SSH / Git-over-SSH and port 3000 for Forgejo HTTP web client
      allowedTCPPorts = [ 22 3000 ];
    };
  };
}
