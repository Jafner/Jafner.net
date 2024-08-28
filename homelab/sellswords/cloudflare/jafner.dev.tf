resource "cloudflare_record" "ipv4_1_githubpages_jafner_dev" {
  content = "185.199.108.153"
  name    = "jafner.dev"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "ipv4_2_githubpages_jafner_dev" {
  content = "185.199.109.153"
  name    = "jafner.dev"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "ipv4_3_githubpages_jafner_dev" {
  content = "185.199.110.153"
  name    = "jafner.dev"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "ipv4_4_githubpages_jafner_dev" {
  content = "185.199.111.153"
  name    = "jafner.dev"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "ipv6_1_githubpages_jafner_dev" {
  content = "2606:50c0:8000::153"
  name    = "jafner.dev"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "ipv6_2_githubpages_jafner_dev" {
  content = "2606:50c0:8001::153"
  name    = "jafner.dev"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "ipv6_3_githubpages_jafner_dev" {
  content = "2606:50c0:8002::153"
  name    = "jafner.dev"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "ipv6_4_githubpages_jafner_dev" {
  content = "2606:50c0:8003::153"
  name    = "jafner.dev"
  proxied = false
  ttl     = 1
  type    = "AAAA"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "nginx1_jafner_dev" {
  content = data.http.myip.response_body
  name    = "nginx1"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "www_jafner_dev" {
  content = "jafner.dev"
  name    = "www"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "verify_protonmail_jafner_dev" {
  content = "protonmail-verification=5a6c959042fa2f5094a7203c11050d0091c3c74d"
  name    = "jafner.dev"
  proxied = false
  ttl     = 1
  type    = "TXT"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "mx_protonmail_jafner_dev" {
  content = "mail.protonmail.ch"
  name    = "jafner.dev"
  proxied = false
  type    = "MX"
  priority = "10"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "mxsecure_protonmail_jafner_dev" {
  content = "mailsec.protonmail.ch"
  name    = "jafner.dev"
  proxied = false
  type    = "MX"
  priority = "20"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "spf_protonmail_jafner_dev" {
  content = "v=spf1 include:_spf.protonmail.ch ~all"
  name    = "jafner.dev"
  proxied = false
  type    = "TXT"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "dkim1_protonmail_jafner_dev" {
  content = "protonmail.domainkey.ds7tmy256idh6c2lnaagep4h2kui25dtk6euypz3i4niemc6fbygq.domains.proton.ch."
  name    = "protonmail._domainkey"
  proxied = false
  type    = "CNAME"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "dkim2_protonmail_jafner_dev" {
  content = "protonmail2.domainkey.ds7tmy256idh6c2lnaagep4h2kui25dtk6euypz3i4niemc6fbygq.domains.proton.ch."
  name    = "protonmail2._domainkey"
  proxied = false
  type    = "CNAME"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "dkim3_protonmail_jafner_dev" {
  content = "protonmail3.domainkey.ds7tmy256idh6c2lnaagep4h2kui25dtk6euypz3i4niemc6fbygq.domains.proton.ch."
  name    = "protonmail3._domainkey"
  proxied = false
  type    = "CNAME"
  zone_id = data.cloudflare_zone.jafner_dev.id
}

resource "cloudflare_record" "dmarc_protonmail_jafner_dev" {
  content = "v=DMARC1; p=quarantine"
  name    = "_dmarc"
  proxied = false
  type    = "TXT"
  zone_id = data.cloudflare_zone.jafner_dev.id
}