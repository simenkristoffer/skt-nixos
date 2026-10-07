# mysql.nix
{ pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mysql84; # Forces official MySQL 8.0 instead of MariaDB

    # Automatically provisions your local development environment
    ensureDatabases = [ "DB1102" ];
    ensureUsers = [
      {
        name = "simen";
        ensurePermissions = { "DB1102.*" = "ALL PRIVILEGES"; };
      }
    ];
  };

  # Optional: Automatically installs the MySQL CLI client system-wide
  environment.systemPackages = [ pkgs.mysql84 ];
}

