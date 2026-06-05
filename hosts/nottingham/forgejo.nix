{ config, lib, pkgs, ... }:

{
  services.forgejo = {
    enable = true;
    database.type = "sqlite3";
    repositoryRoot = "/var/repos";
    settings = {
      server = {
        DOMAIN = "nottingham.daudi.dev";
        HTTP_PORT = 80;
        ROOT_URL = "http://nottingham.daudi.dev:80/";
        HTTP_ADDR = "0.0.0.0";
      };
    };
  };
}
