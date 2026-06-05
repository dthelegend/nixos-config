let
  mixins = {
    ssh-support = ./ssh-support.nix;
    default-system = ./default-system.nix;
    nix-config = ./nix-config.nix;
    cache-client = ./cache-client.nix;
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
        cache-client
      ];
    }
  );
  cambridge = import ./cambridge;
  milton-keynes = import ./milton-keynes;
  dar-es-salaam = import ./dar-es-salaam;
  accra = import ./accra;
  dallas = import ./dallas;
  nottingham = import ./nottingham;
}
