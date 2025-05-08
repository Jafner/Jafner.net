{ pkgs
, config
, ...
}:
let
  cfg = config.modules.hardware.networking;
in
{
  options = with pkgs.lib; {
    modules.hardware.networking = {
      enable = mkEnableOption "networking";
      username = mkOption {
        type = types.str;
        default = "admin";
        description = "Username of the default, primary user.";
        example = "john";
      };
      hostname = mkOption {
        type = types.str;
        default = "nixos";
        description = "Hostname for the system.";
        example = "john-laptop";
      };
      gatewayIP = mkOption {
        type = types.str;
        default = "192.168.1.1";
        description = "IP address of for the default gateway (router).";
        example = "10.0.0.1";
      };
      interface = mkOption {
        type = types.str;
        default = "eth0";
        description = "Name of the primary network interface.";
        example = "wlan0";
      };
      mac = mkOption {
        type = types.str;
        default = null;
        description = "MAC address for the primary network interface to use.";
        example = "AA:BB:CC:DD:00:11";
      };
      ip = mkOption {
        type = types.str;
        default = null;
        description = "IP address for the primary network interface to use.";
        example = "192.168.1.99";
      };
      dns = mkOption {
        type = types.listOf types.str;
        default = null;
        description = "List of nameservers. It can be left empty to be auto-detected via DHCP.";
        example = [
          "1.1.1.1"
          "8.8.8.8"
          "10.0.0.10"
        ];
      };
    };
  };
  config = pkgs.lib.mkIf cfg.enable {
    users.users."${cfg.username}".extraGroups = [ "networkmanager" ];
    networking = {
      hostName = cfg.hostname;
      defaultGateway = {
        address = cfg.gatewayIP;
        interface = cfg.interface;
      };
      interfaces."${cfg.interface}" = {
        useDHCP = true;
        macAddress = cfg.mac;
        ipv4.addresses = [
          {
            address = cfg.ip;
            prefixLength = 24;
          }
        ];
      };
      nameservers = cfg.dns;
    };
  };
}
