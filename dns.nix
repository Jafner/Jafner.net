{
  defaultTTL = 86400;
  zones = {
    "jafner.net" = {
      "" = {
        soa = {
          data = {
            rname = "joey.jafner.net";
            mname = "ns.cloudflare.com";
            serial = 2049550468;
            refresh = 10000;
            retry = 2400;
            ttl = 3600;
            expire = 604800;
          };
        };
        ns = {
          data = [
            "jobs.ns.cloudflare.com"
            "maeve.ns.cloudflare.com"
          ];
        };
        mx = {
          data = [
            "mail.protonmail.ch"
            "mailsec.protonmail.ch"
          ];
        };
        txt.data = [
          "v=spf1 include:_spf.protonmail.ch ~all"
          "protonmail-verification=9ace10d9bb99433b56318ee90826fbff3b80fb91"
        ];
        a.data = [ "97.113.241.118" ];
      };
      "_dmarc".txt.data = "v=DMARC1; p=quarantine";
      "*".cname.data = "jafner.net";
      "protonmail._domainkey".cname.data = "protonmail.domainkey.djxxgyo3stmnxbea3zrilgfg6ubqvox2hrpxff2krv5dd57kqd4ga.domains.proton.ch";
      "protonmail2._domainkey".cname.data = "protonmail2.domainkey.djxxgyo3stmnxbea3zrilgfg6ubqvox2hrpxff2krv5dd57kqd4ga.domains.proton.ch";
      "protonmail3._domainkey".cname.data = "protonmail3.domainkey.djxxgyo3stmnxbea3zrilgfg6ubqvox2hrpxff2krv5dd57kqd4ga.domains.proton.ch";
    };
  };
}
