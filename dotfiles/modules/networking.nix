{ networking, sys, ... }: {
  users.users."${sys.username}".extraGroups = [ "networkmanager" ];
  networking = {
    hostName = networking.hostname;
    defaultGateway = { address = networking.gatewayIP; interface = networking.interface; };
    interfaces."${networking.interface}" = {
      useDHCP = true;
      macAddress = networking.mac;
      ipv4.addresses = [ { address = networking.ip; prefixLength = 24; } ];
    };
    nameservers = networking.dns;
  };
}