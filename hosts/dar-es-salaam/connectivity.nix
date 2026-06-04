{ config, lib, pkgs, ... }:

let
  network = import ../network.nix;
  hostConfig = network.hosts.dar-es-salaam;
in
{
  networking = {
    hostName = "dar-es-salaam";
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

    # Default-drop firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 41641 ];
    };
  };

  # Tailscale setup
  services.tailscale = {
    enable = true;
    port = 41641;
    useRoutingFeatures = "both";
    extraUpFlags = [
      "--advertise-routes=192.168.1.0/24"
      "--advertise-exit-node"
    ];
  };

  # IP packet forwarding required for subnet router and exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
