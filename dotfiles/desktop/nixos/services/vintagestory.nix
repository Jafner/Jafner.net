{ ... }: {
  networking.firewall = {
    allowedTCPPorts = [ 42420 ];
    allowedUDPPorts = [ 42420 ];
  };
}
