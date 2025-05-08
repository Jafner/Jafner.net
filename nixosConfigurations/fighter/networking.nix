{ ... }: {
  systemd.network = {
    enable = true;
    networks."50-enp3s0" = {
      address = [
        "192.168.1.23/24"
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
          Source = "192.168.1.23";
        }
      ];
      matchConfig.Name = "enp3s0";
      linkConfig.RequiredForOnline = "routable";
    };
  };
  networking.useNetworkd = true;
  networking.useDHCP = false;
}
