{ ... }: {
  systemd.network = {
    enable = true;
    networks."50-enp4s0f0" = {
      address = [
        "192.168.1.135/24"
      ];
      dns = [
        "192.168.1.1"
        "10.0.0.1"
      ];
      gateway = [ "192.168.1.1" ];
      routes = [
        {
          Gateway = "192.168.1.1";
          GatewayOnLink = true;
          Destination = "192.168.1.0/24";
          Source = "192.168.1.135";
        }
      ];
      matchConfig.Name = "enp4s0f0";
      linkConfig.RequiredForOnline = "routable";
    };
  };
  networking.useNetworkd = true;
  networking.useDHCP = false;
}
