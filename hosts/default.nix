let
  mixins = {
    ssh-support = ./ssh-support.nix;
    default-system = ./default-system.nix;
    nix-config = ./nix-config.nix;
  };
in
{
  inherit mixins;

  default-mixins = (
    {
      ...
    }:
    {
      imports = with mixins; [
        default-system
        nix-config
      ];
    }
  );
  cambridge = import ./cambridge;
  milton-keynes = import ./milton-keynes;
  minecraft-server = import ./minecraft-server;
}
