let
  options = {
    ssh-support = ./ssh-support.nix;
    default-system = ./default-system.nix;
    nix-config = ./nix-config.nix;
  };
in
{
  inherit options;

  defaults = (
    {
      ...
    }:
    {
      imports = with options; [
        default-system
        nix-config
      ];
    }
  );
  cambridge = import ./cambridge;
  minecraft-server = import ./minecraft-server;
}
