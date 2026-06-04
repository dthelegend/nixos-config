{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./graphical.nix
  ];

  config = {
    # User Accounts
    users = {
      users.daudi = {
        isNormalUser = true;
        description = "Daudi Wampamba";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
      defaultUserShell = pkgs.fish;
    };

    environment.variables = {
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };
}
