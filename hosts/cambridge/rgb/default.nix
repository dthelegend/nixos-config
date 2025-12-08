{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  boot.kernelModules = [ "i2c-dev" ];
  hardware.i2c.enable = true;
  services.hardware.openrgb = {
    package = pkgs.openrgb;
    enable = true;
    motherboard = "amd";
  };
  systemd.services.openrgb = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "lm_sensors.service"
    ];
    description = "OpenRGB SDK Server";
    serviceConfig = {
      RemainAfterExit = "yes";
      ExecStart = ''${pkgs.openrgb}/bin/openrgb --server'';
      Restart = "always";
    };
    enable = false;
  };

  systemd.services.initialise_rgb =
    let
      colour = "red";
      openrgb_config = ./config;
    in
    {
      description = "OpenRGB set all to '${colour}'";
      serviceConfig = {
        ExecStart = ''sleep 5 && {pkgs.openrgb}/bin/openrgb -vv --noautoconnect --config ${openrgb_config} --mode direct -c "${colour}"'';
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
}
