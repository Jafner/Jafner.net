{ wireguard, sys, ... }: {
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wireguard = {
    enable = true;
    interfaces = {
      wg0 = {
        ips = [ "192.168.100.1/24" ];
        listenPort = 51820;
        privateKeyFile = "/run/secrets/wireguard";
      };
    };
  };
  sops.secrets."wireguard" = { 
    sopsFile = wireguard.secretsFile;
    format = "binary";
    key = "";
    mode = "0440";
    owner = sys.username;
  };
}

# j+rBgqdGz5PKvowDJrYkP2JRqFUCQnlFPQgwjAH+4zo= # pubkey for desktop