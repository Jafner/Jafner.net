{hostname, ...}: {
  services.tailscale.enable = false;
  systemd.network = {
    enable = true;
    networks."50-enp3s0" = {
      address = [
        "192.168.0.234/24"
      ];
      dns = [
        "192.168.0.1"
        "10.00.0.1"
      ];
      gateway = ["192.168.0.1"];
      routes = [
        {
          Gateway = "192.168.0.1";
          GatewayOnLink = true;
          Destination = "192.168.0.0/24";
          Source = "192.168.0.234";
        }
      ];
      matchConfig.Name = "enp3s0*";
      linkConfig.RequiredForOnline = "routable";
    };
  };
  networking.useNetworkd = true;
  networking.useDHCP = false;
  networking.hostName = hostname;
  networking.hosts = {
    "143.198.68.202" = ["artificer"];
    "172.245.108.219" = ["champion"];
  };
}
