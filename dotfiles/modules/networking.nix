{ networking, ... }: {
  networking = {
    hostName = networking.hostname;
    defaultGateway = { address = networking.ip; interface = networking.interface; };
    interfaces."${networking.interface}" = {
      useDHCP = true;
      macAddress = networking.mac;
      ipv4.addresses = [ { address = networking.ip; prefixLength = 24; } ];
    };
    nameservers = networking.dns;
  };
}