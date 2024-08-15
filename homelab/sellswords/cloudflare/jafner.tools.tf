resource "cloudflare_record" "any_jafner_tools" {
  content = "143.110.151.123"
  name    = "*"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_tools.id
}

resource "cloudflare_record" "root_jafner_tools" {
  content = "143.110.151.123"
  name    = "jafner.tools"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zone.jafner_tools.id
}

