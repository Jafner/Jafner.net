{ ... }: {
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8080;
    user = "headscale";
    group = "headscale";
    settings = {
      server_url = "https://vpn.jafner.net";
      tls_letsencrypt_hostname = "vpn.jafner.net";
      database = {
        type = "sqlite";
        sqlite = {
          path = "/var/lib/headscale/db.sqlite";
          write_ahead_log = true;
        };
      };
      dns = {
        nameservers.global = [  ];
        base_domain = "jafner.net";
        magic_dns = true;
        search_domains = [  ];
      };
    };
  };
}