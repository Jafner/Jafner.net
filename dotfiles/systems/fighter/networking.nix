{ sys, ... }: {
  networking = {
    hostName = "fighter";
    defaultGateway = { address = "192.168.1.1"; interface = "enp3s0"; };
    interfaces."enp3s0" = {
      useDHCP = true;
      macAddress = "00:02:c9:56:bf:9a";
      ipv4.addresses = [ { address = "192.168.1.23"; prefixLength = 24; } ];
    };
    nameservers = [ "10.0.0.1" ];
    firewall.allowedTCPPorts = [
      5201
    ];
  };
}