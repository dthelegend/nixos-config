{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "me+letsencrypt@daudi.dev";
    certs."minecraft.daudi.dev" = {
      reloadServices = [ "static-web-server" ];
      listenHTTP = ":80";
      group = "www-data";
      # EC is not supported by SWS versions before 2.16.1
      keyType = "rsa4096";
    };
  };

  # Configure SWS to use the generated TLS certs
  services.static-web-server = {
    enable = true;
    root = "${pkgs.munchcraft}";
    listen = "[::]:443";
    configuration = {
      general = {
        http2 = true;
        # Edit the domain name in the file to match your real domain name as configured in the ACME settings
        http2-tls-cert = "/var/lib/acme/minecraft.daudi.dev/fullchain.pem";
        http2-tls-key = "/var/lib/acme/minecraft.daudi.dev/key.pem";
        # Info here: https://static-web-server.net/features/security-headers/
        # This option is only needed for versions prior to 2.18.0, after which it defaults to true
        security-headers = true;
      };
    };
  };

  # Now we need to override some things in the systemd unit files to allow access to those TLS certs, starting with creating a new Linux group:
  users.groups.www-data = { };
  # This strategy can be useful to override other advanced features as-needed
  systemd.services.static-web-server.serviceConfig.SupplementaryGroups = pkgs.lib.mkForce [
    ""
    "www-data"
  ];
  # Note that "/some/path" should match your "root" option
  systemd.services.static-web-server.serviceConfig.BindReadOnlyPaths = pkgs.lib.mkForce [
    "${pkgs.munchcraft}"
    "/var/lib/acme/minecraft.daudi.dev"
  ];
}
