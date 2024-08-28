resource "cloudflare_record" "a5e_jafner_net" {
  content = "34.49.168.203"
  name    = "5e"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "root_jafner_net" {
  content = chomp(data.http.myip.response_body)
  name    = "jafner.net"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "any_jafner_net" {
  content = "jafner.net"
  name    = "*"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "dkim1_protonmail_jafner_net" {
  content = "protonmail.domainkey.djxxgyo3stmnxbea3zrilgfg6ubqvox2hrpxff2krv5dd57kqd4ga.domains.proton.ch"
  name    = "protonmail._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "dkim2_protonmail_jafner_net" {
  content = "protonmail2.domainkey.djxxgyo3stmnxbea3zrilgfg6ubqvox2hrpxff2krv5dd57kqd4ga.domains.proton.ch"
  name    = "protonmail2._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "dkim3_protonmail_jafner_net" {
  content = "protonmail3.domainkey.djxxgyo3stmnxbea3zrilgfg6ubqvox2hrpxff2krv5dd57kqd4ga.domains.proton.ch"
  name    = "protonmail3._domainkey"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "mx_protonmail_jafner_net" {
  content  = "mail.protonmail.ch"
  name     = "jafner.net"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "mxsecure_protonmail_jafner_net" {
  content  = "mailsec.protonmail.ch"
  name     = "jafner.net"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  zone_id  = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "dmarc_protonmail_jafner_net" {
  content = "v=DMARC1; p=quarantine"
  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "spf_protonmail_jafner_net" {
  content = "v=spf1 include:_spf.protonmail.ch ~all"
  name    = "jafner.net"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = data.cloudflare_zone.jafner_net.id
}

resource "cloudflare_record" "verify_protonmail_jafner_net" {
  content = "protonmail-verification=9ace10d9bb99433b56318ee90826fbff3b80fb91"
  name    = "jafner.net"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = data.cloudflare_zone.jafner_net.id
}

